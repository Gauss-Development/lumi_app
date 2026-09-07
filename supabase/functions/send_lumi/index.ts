import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

const PACE_LIMIT_PER_DAY = 5;
const ALLOWED_TYPES = new Set(["pure", "light", "pulse", "doodle"]);

type JsonRecord = Record<string, unknown>;

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return json({ error: "Method not allowed." }, 405);
  }

  try {
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
    const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
    if (!supabaseUrl || !serviceRoleKey || !anonKey) {
      return json({ error: "Supabase environment is not configured." }, 500);
    }

    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return json({ error: "Missing Authorization header." }, 401);
    }

    const userClient = createClient(supabaseUrl, anonKey, {
      global: { headers: { Authorization: authHeader } },
    });
    const admin = createClient(supabaseUrl, serviceRoleKey);

    const {
      data: { user },
      error: userError,
    } = await userClient.auth.getUser();
    if (userError || !user) {
      return json({ error: "Unauthorized." }, 401);
    }

    const body = (await req.json()) as JsonRecord;
    const claimedSenderId = requiredString(body, "senderId");
    if (claimedSenderId !== user.id) {
      return json({ error: "senderId does not match the session user." }, 403);
    }

    const senderMemberId = requiredString(body, "senderMemberId");
    const type = requiredString(body, "type");
    if (!ALLOWED_TYPES.has(type)) {
      return json({ error: "Unsupported Lumi type." }, 400);
    }

    const pulsePatternJson = body.pulsePatternJson as string | null | undefined;
    const doodleStrokeJson = body.doodleStrokeJson as string | null | undefined;
    validatePayload(type, pulsePatternJson, doodleStrokeJson);

    const { data: member, error: memberError } = await admin
      .from("circle_members")
      .select("*")
      .eq("id", senderMemberId)
      .maybeSingle();

    if (memberError || !member) {
      return json({ error: "Circle member not found." }, 404);
    }
    if (member.owner_user_id !== user.id) {
      return json({ error: "This circle member is not owned by you." }, 403);
    }
    if (member.status !== "active" || member.mutual_connection !== true) {
      return json({ error: "This circle member is not connected." }, 409);
    }

    const recipientUserId = member.member_user_id as string | null;
    const recipientMemberId = member.reciprocal_member_id as string | null;
    if (!recipientUserId || !recipientMemberId) {
      return json({ error: "Circle member is not linked." }, 409);
    }

    if (isAtPaceLimit(member)) {
      return json(
        {
          error:
            "Gentle limit reached for this person today. Try again tomorrow.",
        },
        429,
      );
    }

    const intensity = Math.min(
      1,
      Math.max(0.2, Number(body.intensity ?? 0.7)),
    );
    const deliveryStatus =
      (body.deliveryStatus as string | undefined) ?? "delivered";

    const { data: lumi, error: insertError } = await admin
      .from("lumis")
      .insert({
        sender_id: user.id,
        recipient_id: recipientUserId,
        sender_member_id: senderMemberId,
        recipient_member_id: recipientMemberId,
        circle_id: senderMemberId,
        type,
        color_value: (body.colorValue as number | undefined) ?? 4286579307,
        intensity,
        delivery_status: deliveryStatus,
        pulse_pattern_json: pulsePatternJson ?? null,
        doodle_stroke_json: doodleStrokeJson ?? null,
        created_at: new Date().toISOString(),
      })
      .select()
      .single();

    if (insertError || !lumi) {
      return json({ error: insertError?.message ?? "Could not send Lumi." }, 500);
    }

    await admin
      .from("circle_members")
      .update({
        pace_count: nextPaceCount(member),
        last_interaction_at: new Date().toISOString(),
      })
      .eq("id", senderMemberId);

    await sendPushNotification(admin, {
      recipientUserId,
      lumiId: lumi.id as string,
      senderMemberId,
      recipientMemberId,
      type,
      senderName: (member.display_name as string) ?? "Someone",
      senderColorValue:
        (member.signature_color_value as number | undefined) ?? 4286579307,
    });

    return json(lumi, 201);
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    const status = error instanceof FormatError ? 400 : 500;
    return json({ error: message }, status);
  }
});

class FormatError extends Error {}

function requiredString(body: JsonRecord, key: string): string {
  const value = body[key];
  if (typeof value === "string" && value.length > 0) {
    return value;
  }
  throw new FormatError(`${key} is required.`);
}

function validatePayload(
  type: string,
  pulsePatternJson?: string | null,
  doodleStrokeJson?: string | null,
): void {
  if (type === "pulse") {
    if (!pulsePatternJson) {
      throw new FormatError("pulsePatternJson is required for pulse.");
    }
    const decoded = JSON.parse(pulsePatternJson) as JsonRecord;
    const beats = (decoded.beats as unknown[]) ?? [];
    if (beats.length < 2) {
      throw new FormatError("Pulse needs at least two beat intervals.");
    }
  }
  if (type === "doodle") {
    if (!doodleStrokeJson) {
      throw new FormatError("doodleStrokeJson is required for doodle.");
    }
    const decoded = JSON.parse(doodleStrokeJson) as JsonRecord;
    const points = (decoded.points as unknown[]) ?? [];
    if (points.length < 2) {
      throw new FormatError("Doodle needs at least two points.");
    }
  }
}

function isAtPaceLimit(member: JsonRecord): boolean {
  const paceCount = Number(member.pace_count ?? 0);
  const lastInteractionRaw = member.last_interaction_at as string | null;
  if (!lastInteractionRaw) {
    return false;
  }
  const lastInteraction = new Date(lastInteractionRaw).getTime();
  const hoursSince = (Date.now() - lastInteraction) / (1000 * 60 * 60);
  if (hoursSince >= 24) {
    return false;
  }
  return paceCount >= PACE_LIMIT_PER_DAY;
}

function nextPaceCount(member: JsonRecord): number {
  const paceCount = Number(member.pace_count ?? 0);
  const lastInteractionRaw = member.last_interaction_at as string | null;
  if (!lastInteractionRaw) {
    return 1;
  }
  const hoursSince =
    (Date.now() - new Date(lastInteractionRaw).getTime()) / (1000 * 60 * 60);
  if (hoursSince >= 24) {
    return 1;
  }
  return paceCount + 1;
}

async function sendPushNotification(
  admin: ReturnType<typeof createClient>,
  params: {
    recipientUserId: string;
    lumiId: string;
    senderMemberId: string;
    recipientMemberId: string;
    type: string;
    senderName: string;
    senderColorValue: number;
  },
): Promise<void> {
  const serverKey = Deno.env.get("FIREBASE_SERVER_KEY");
  if (!serverKey) {
    return;
  }

  const { data: tokens } = await admin
    .from("push_tokens")
    .select("fcm_token")
    .eq("user_id", params.recipientUserId);

  if (!tokens?.length) {
    return;
  }

  const senderName = params.senderName.trim() || "Someone";
  const payload = {
    notification: {
      title: "Lumi",
      body: `A Lumi from ${senderName}`,
    },
    data: {
      lumiId: params.lumiId,
      senderMemberId: params.senderMemberId,
      recipientMemberId: params.recipientMemberId,
      type: params.type,
      senderName,
      senderColorValue: String(params.senderColorValue),
    },
  };

  for (const row of tokens) {
    const token = row.fcm_token as string;
    if (!token) continue;
    try {
      await fetch("https://fcm.googleapis.com/fcm/send", {
        method: "POST",
        headers: {
          Authorization: `key=${serverKey}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ to: token, ...payload }),
      });
    } catch {
      // Push is optional; lumis row is source of truth.
    }
  }
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}
