-- Ekebol QLD Floor Schedule — Supabase setup. Run the WHOLE file once in a NEW Supabase project:
--   Supabase dashboard > SQL Editor > New query > paste this > Run.
-- It is safe to run again. Use a NEW project for Ekebol (not the Southern Spreaders one).

-- 1. The shared schedule: one row holding the whole app state as JSON.
create table if not exists app_state (
  id text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);
alter table app_state enable row level security;

-- 2. Logins: which Supabase Auth account has which role in the app.
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  role text not null default 'floor' check (role in ('manager','floor','sales')),
  person_id text,
  created_at timestamptz not null default now()
);
alter table profiles enable row level security;

-- Helpers used inside the policies (security definer avoids a policy querying its own table recursively).
create or replace function is_manager()
returns boolean language sql security definer set search_path = public as $$
  select exists (select 1 from profiles where id = auth.uid() and role = 'manager');
$$;
create or replace function has_profile()
returns boolean language sql security definer set search_path = public as $$
  select exists (select 1 from profiles where id = auth.uid());
$$;

-- 3. Who can do what.
--    app_state: only people who have a profile row (so a stranger who signs up cannot read or change the schedule).
drop policy if exists "profiled users read/write" on app_state;
create policy "profiled users read/write" on app_state
  for all to authenticated
  using (has_profile())
  with check (has_profile());

--    profiles: you can read your own; managers can read and manage everyone's.
drop policy if exists "read own profile" on profiles;
create policy "read own profile" on profiles for select to authenticated using (auth.uid() = id);

drop policy if exists "managers read all profiles" on profiles;
create policy "managers read all profiles" on profiles for select to authenticated using (is_manager());

drop policy if exists "managers manage profiles" on profiles;
create policy "managers manage profiles" on profiles for all to authenticated
  using (is_manager()) with check (is_manager());

-- 4. YOUR FIRST LOGIN (do this after creating your user under Authentication > Users):
--    replace the email below with the one you created, remove the two dashes at the start of each line, and Run it.
--
-- insert into profiles (id, email, role)
-- select id, email, 'manager' from auth.users where email = 'you@example.com'
-- on conflict (id) do update set role = 'manager';
