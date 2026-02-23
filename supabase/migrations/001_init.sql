create extension if not exists "pgcrypto";

create type public.app_role as enum ('COACH', 'CLIENT');
create type public.load_type as enum ('kg', 'percent_1rm', 'rpe', 'rir', 'bodyweight');
create type public.session_status as enum ('scheduled', 'in_progress', 'completed', 'skipped');

create table public.profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  role public.app_role not null,
  display_name text not null,
  deleted_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.coach_client_links (
  id uuid primary key default gen_random_uuid(),
  coach_id uuid not null references public.profiles(user_id) on delete cascade,
  client_id uuid not null references public.profiles(user_id) on delete cascade,
  invite_code text not null unique,
  created_at timestamptz not null default now(),
  unique(coach_id, client_id)
);

create table public.exercises (
  id uuid primary key default gen_random_uuid(),
  coach_id uuid not null references public.profiles(user_id) on delete cascade,
  shared boolean not null default false,
  name text not null,
  category text not null,
  equipment text not null,
  tags text[] not null default '{}',
  instructions text not null,
  coaching_cues text[] not null default '{}',
  media_url text,
  image_path text,
  created_at timestamptz not null default now()
);

create table public.program_templates (
  id uuid primary key default gen_random_uuid(),
  coach_id uuid not null references public.profiles(user_id) on delete cascade,
  name text not null,
  objective text not null,
  duration_weeks int not null check(duration_weeks between 1 and 52),
  tags text[] not null default '{}'
);

create table public.blocks (
  id uuid primary key default gen_random_uuid(),
  template_id uuid not null references public.program_templates(id) on delete cascade,
  week_start int not null,
  week_end int not null,
  focus text not null,
  notes text
);

create table public.session_templates (
  id uuid primary key default gen_random_uuid(),
  block_id uuid not null references public.blocks(id) on delete cascade,
  relative_day int not null,
  name text not null,
  estimated_duration_min int not null
);

create table public.session_exercises (
  id uuid primary key default gen_random_uuid(),
  session_template_id uuid not null references public.session_templates(id) on delete cascade,
  exercise_id uuid not null references public.exercises(id) on delete restrict,
  order_index int not null,
  instructions text
);

create table public.set_prescriptions (
  id uuid primary key default gen_random_uuid(),
  session_exercise_id uuid not null references public.session_exercises(id) on delete cascade,
  set_index int not null,
  reps text not null,
  load_type public.load_type not null,
  load_value numeric,
  tempo text,
  rest_sec int,
  target_rpe numeric,
  pain_limit int,
  rom_note text
);

create table public.program_assignments (
  id uuid primary key default gen_random_uuid(),
  client_id uuid not null references public.profiles(user_id) on delete cascade,
  template_id uuid not null references public.program_templates(id) on delete cascade,
  start_date date not null,
  weeks int not null check(weeks between 4 and 12),
  created_by uuid not null references public.profiles(user_id)
);

create table public.session_instances (
  id uuid primary key default gen_random_uuid(),
  assignment_id uuid not null references public.program_assignments(id) on delete cascade,
  client_id uuid not null references public.profiles(user_id) on delete cascade,
  session_template_id uuid not null references public.session_templates(id),
  date date not null,
  status public.session_status not null default 'scheduled'
);

create table public.set_logs (
  id uuid primary key default gen_random_uuid(),
  session_instance_id uuid not null references public.session_instances(id) on delete cascade,
  exercise_id uuid not null references public.exercises(id),
  set_index int not null,
  reps_done int,
  load_done numeric,
  rpe_done numeric,
  pain_done int,
  note text,
  created_at timestamptz not null default now()
);

create table public.session_feedback (
  session_instance_id uuid primary key references public.session_instances(id) on delete cascade,
  client_note text,
  coach_note text,
  created_at timestamptz not null default now()
);

create index on public.coach_client_links(coach_id);
create index on public.coach_client_links(client_id);
create index on public.exercises(coach_id);
create index on public.program_assignments(client_id, start_date);
create index on public.session_instances(client_id, date);
create index on public.set_logs(session_instance_id);
