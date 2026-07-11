-- Run this whole file in Supabase: Dashboard -> SQL Editor -> New query -> paste -> Run

-- Tasks / assignments / exams
create table public.tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  title text not null,
  due_date date,
  priority text default 'Medium',
  done boolean default false,
  created_at timestamp with time zone default now()
);

-- Hourly schedule (6am-midnight), one row per user per hour
create table public.schedule_slots (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  hour int not null,
  text text default '',
  category text default 'Class',
  updated_at timestamp with time zone default now(),
  unique (user_id, hour)
);

-- Lock both tables down so users can only ever see/edit their own rows
alter table public.tasks enable row level security;
alter table public.schedule_slots enable row level security;

create policy "Users manage own tasks"
  on public.tasks
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users manage own schedule"
  on public.schedule_slots
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
