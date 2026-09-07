-- Presence heartbeats: lightweight "app opened" signal for together-moment detection.

create table public.presence_heartbeats (
  user_id uuid primary key references auth.users (id) on delete cascade,
  last_opened_at timestamptz not null default timezone('utc', now())
);

create index presence_heartbeats_last_opened_at_idx
  on public.presence_heartbeats (last_opened_at desc);

alter table public.presence_heartbeats enable row level security;

create policy "presence_heartbeats_select_circle"
  on public.presence_heartbeats for select
  to authenticated
  using (
    user_id = auth.uid()
    or user_id in (
      select cm.member_user_id
      from public.circle_members cm
      where cm.owner_user_id = auth.uid()
        and cm.mutual_connection = true
        and cm.member_user_id is not null
    )
  );

create policy "presence_heartbeats_insert_own"
  on public.presence_heartbeats for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "presence_heartbeats_update_own"
  on public.presence_heartbeats for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
