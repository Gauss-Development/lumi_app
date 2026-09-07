-- Lumi initial Supabase schema.
-- Remote tables: profiles, circle_members, invitations, lumis, push_tokens.
-- Local-only (not synced): settings, kept_lumis/shelf, onboarding, doodle drafts.

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------------
-- profiles
-- ---------------------------------------------------------------------------
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text,
  phone text,
  name text,
  display_name text not null default '',
  avatar_style text not null default 'avatar_0',
  signature_color_value integer not null default 4286579307,
  photo_url text,
  created_at timestamptz not null default timezone('utc', now())
);

alter table public.profiles enable row level security;

create policy "profiles_select_own"
  on public.profiles for select
  using (auth.uid() = id);

create policy "profiles_insert_own"
  on public.profiles for insert
  with check (auth.uid() = id);

create policy "profiles_update_own"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- ---------------------------------------------------------------------------
-- circle_members
-- ---------------------------------------------------------------------------
create table public.circle_members (
  id text primary key,
  owner_user_id uuid not null references auth.users (id) on delete cascade,
  member_user_id uuid references auth.users (id) on delete set null,
  reciprocal_member_id text,
  invitation_code text,
  display_name text not null,
  signature_color_value integer not null default 4286579307,
  status text not null default 'active',
  relationship_label text,
  muted_until timestamptz,
  pace_count integer not null default 0,
  queued_count integer not null default 0,
  mutual_connection boolean not null default false,
  subtitle text,
  last_interaction_at timestamptz,
  created_at timestamptz not null default timezone('utc', now())
);

create index circle_members_owner_user_id_idx on public.circle_members (owner_user_id);
create index circle_members_member_user_id_idx on public.circle_members (member_user_id);
create index circle_members_invitation_code_idx on public.circle_members (invitation_code);

alter table public.circle_members enable row level security;

create policy "circle_members_select_own"
  on public.circle_members for select
  using (auth.uid() = owner_user_id);

create policy "circle_members_insert_own"
  on public.circle_members for insert
  with check (auth.uid() = owner_user_id);

create policy "circle_members_update_own"
  on public.circle_members for update
  using (auth.uid() = owner_user_id)
  with check (auth.uid() = owner_user_id);

create policy "circle_members_delete_own"
  on public.circle_members for delete
  using (auth.uid() = owner_user_id);

-- ---------------------------------------------------------------------------
-- invitations
-- ---------------------------------------------------------------------------
create table public.invitations (
  code text primary key,
  inviter_user_id uuid not null references auth.users (id) on delete cascade,
  inviter_display_name text not null,
  inviter_signature_color_value integer not null default 4286579307,
  invitee_label text not null,
  invitee_relationship_label text,
  invitee_user_id uuid references auth.users (id) on delete set null,
  invitee_display_name text,
  invitee_signature_color_value integer,
  inviter_member_id text,
  invitee_member_id text,
  status text not null default 'pending',
  created_at timestamptz not null default timezone('utc', now()),
  expires_at timestamptz not null,
  accepted_at timestamptz
);

create index invitations_inviter_user_id_idx on public.invitations (inviter_user_id);

alter table public.invitations enable row level security;

create policy "invitations_select_authenticated"
  on public.invitations for select
  to authenticated
  using (true);

create policy "invitations_insert_own"
  on public.invitations for insert
  with check (auth.uid() = inviter_user_id);

create policy "invitations_update_authenticated"
  on public.invitations for update
  to authenticated
  using (true)
  with check (true);

create policy "invitations_delete_own"
  on public.invitations for delete
  using (auth.uid() = inviter_user_id);

-- ---------------------------------------------------------------------------
-- lumis
-- ---------------------------------------------------------------------------
create table public.lumis (
  id uuid primary key default gen_random_uuid(),
  sender_id uuid not null references auth.users (id) on delete cascade,
  recipient_id uuid not null references auth.users (id) on delete cascade,
  circle_id text,
  sender_member_id text,
  recipient_member_id text,
  type text not null,
  color_value integer not null default 4286579307,
  intensity double precision not null default 0.7,
  delivery_status text not null default 'delivered',
  pulse_pattern_json text,
  doodle_stroke_json text,
  seen_at timestamptz,
  reaction_emoji text,
  created_at timestamptz not null default timezone('utc', now())
);

create index lumis_sender_id_idx on public.lumis (sender_id);
create index lumis_recipient_id_idx on public.lumis (recipient_id);
create index lumis_sender_member_id_idx on public.lumis (sender_member_id);
create index lumis_recipient_member_id_idx on public.lumis (recipient_member_id);

alter table public.lumis enable row level security;

create policy "lumis_select_participant"
  on public.lumis for select
  using (auth.uid() = sender_id or auth.uid() = recipient_id);

create policy "lumis_update_recipient"
  on public.lumis for update
  using (auth.uid() = recipient_id)
  with check (auth.uid() = recipient_id);

create policy "lumis_delete_sender"
  on public.lumis for delete
  using (auth.uid() = sender_id);

-- Inserts are performed by the send_lumi edge function (service role).

-- ---------------------------------------------------------------------------
-- push_tokens (FCM device tokens)
-- ---------------------------------------------------------------------------
create table public.push_tokens (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  fcm_token text not null,
  platform text,
  updated_at timestamptz not null default timezone('utc', now()),
  unique (user_id, fcm_token)
);

create index push_tokens_user_id_idx on public.push_tokens (user_id);

alter table public.push_tokens enable row level security;

create policy "push_tokens_select_own"
  on public.push_tokens for select
  using (auth.uid() = user_id);

create policy "push_tokens_insert_own"
  on public.push_tokens for insert
  with check (auth.uid() = user_id);

create policy "push_tokens_update_own"
  on public.push_tokens for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "push_tokens_delete_own"
  on public.push_tokens for delete
  using (auth.uid() = user_id);

-- ---------------------------------------------------------------------------
-- Auto-create profile row on sign-up
-- ---------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, phone, name, display_name)
  values (
    new.id,
    new.email,
    new.phone,
    coalesce(new.raw_user_meta_data->>'name', ''),
    coalesce(new.raw_user_meta_data->>'name', split_part(coalesce(new.email, ''), '@', 1), 'Lumi')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();
