import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

const ALLOWED_REACTIONS = new Set([
  "heart",
  "smile",
  "handOnHeart",
  "sun",
  "moon",
]);

const REACTION_EMOJI: Record<string, string> = {
  heart: "♥",
  smile: "☺",
  handOnHeart: "🤍",
  sun: "☀",
  moon: "☾",
};

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
    const lumiId = requiredString(body, "lumiId");
    const reaction = requiredString(body, "reaction");
    if (!ALLOWED_REACTIONS.has(reaction)) {
      return json({ error: "Unsupported reaction." }, 400);
    }

    const { data: lumi, error: lumiError } = await admin
      .from("lumis")
      .select("*")
      .eq("id", lumiId)
      .maybeSingle();

    if (lumiError || !lumi) {
      return json({ error: "Lumi not found." }, 404);
    }
    if (lumi.recipient_id !== user.id) {
      return json({ error: "Only the recipient can react to this Lumi." }, 403);
    }

    const senderUserId = lumi.sender_id as string;
    const senderMemberId = (lumi.sender_member_id as string | null) ?? "";

    const { data: updated, error: updateError } = await admin
      .from("lumis")
      .update({
        reaction_emoji: reaction,
        delivery_status: "reacted",
        seen_at: new Date().toISOString(),
      })
      .eq("id", lumiId)
      .select()
      .single();

    if (updateError || !updated) {
      return json(
        { error: updateError?.message ?? "Could not save reaction." },
        500,
      );
    }

    const reactorName = await reactorDisplayName(admin, senderMemberId);
    await notifySender(admin, {
      senderUserId,
      lumiId,
      reactorName,
      reaction,
      senderMemberId,
      recipientMemberId: (lumi.recipient_member_id as string | null) ?? "",
    });

    return json(updated, 200);
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

async function reactorDisplayName(
  admin: ReturnType<typeof createClient>,
  senderMemberId: string,
): Promise<string> {
  if (!senderMemberId) {
    return "Someone";
  }
  const { data: member } = await admin
    .from("circle_members")
    .select("display_name")
    .eq("id", senderMemberId)
    .maybeSingle();
  const displayName = (member?.display_name as string | undefined)?.trim();
  return displayName && displayName.length > 0 ? displayName : "Someone";
}

async function notifySender(
  admin: ReturnType<typeof createClient>,
  params: {
    senderUserId: string;
    lumiId: string;
    reactorName: string;
    reaction: string;
    senderMemberId: string;
    recipientMemberId: string;
  },
): Promise<void> {
  const serverKey = Deno.env.get("FIREBASE_SERVER_KEY");
  if (!serverKey) {
    return;
  }

  const { data: tokens } = await admin
    .from("push_tokens")
    .select("fcm_token")
    .eq("user_id", params.senderUserId);

  if (!tokens?.length) {
    return;
  }

  const emoji = REACTION_EMOJI[params.reaction] ?? "♥";
  const payload = {
    notification: {
      title: "Lumi",
      body: `${params.reactorName} felt your Lumi ${emoji}`,
    },
    data: {
      type: "reaction",
      lumiId: params.lumiId,
      reaction: params.reaction,
      senderMemberId: params.senderMemberId,
      recipientMemberId: params.recipientMemberId,
      senderName: params.reactorName,
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
      // Reaction row is source of truth.
    }
  }
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}
