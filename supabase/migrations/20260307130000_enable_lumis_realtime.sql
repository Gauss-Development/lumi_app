-- Enable Supabase Realtime for lumis inbox updates.
-- RLS on lumis limits which row events each authenticated user receives.

alter table public.lumis replica identity full;

alter publication supabase_realtime add table public.lumis;
