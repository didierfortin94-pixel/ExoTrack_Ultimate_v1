alter table public.profiles enable row level security;
alter table public.coach_client_links enable row level security;
alter table public.exercises enable row level security;
alter table public.program_templates enable row level security;
alter table public.blocks enable row level security;
alter table public.session_templates enable row level security;
alter table public.session_exercises enable row level security;
alter table public.set_prescriptions enable row level security;
alter table public.program_assignments enable row level security;
alter table public.session_instances enable row level security;
alter table public.set_logs enable row level security;
alter table public.session_feedback enable row level security;

create policy "profiles self or linked coach/client" on public.profiles
for select using (
  auth.uid() = user_id
  or exists (
    select 1 from public.coach_client_links ccl
    where (ccl.coach_id = auth.uid() and ccl.client_id = profiles.user_id)
       or (ccl.client_id = auth.uid() and ccl.coach_id = profiles.user_id)
  )
);

create policy "profiles self update" on public.profiles
for update using (auth.uid() = user_id);

create policy "coach manages links" on public.coach_client_links
for all using (coach_id = auth.uid()) with check (coach_id = auth.uid());

create policy "coach owns exercises" on public.exercises
for all using (coach_id = auth.uid()) with check (coach_id = auth.uid());

create policy "client can read shared + linked exercises" on public.exercises
for select using (
  shared = true
  or exists (
    select 1 from public.coach_client_links ccl
    where ccl.client_id = auth.uid() and ccl.coach_id = exercises.coach_id
  )
);

create policy "coach owns templates" on public.program_templates
for all using (coach_id = auth.uid()) with check (coach_id = auth.uid());

create policy "coach reads blocks via template" on public.blocks
for all using (
  exists (
    select 1 from public.program_templates pt
    where pt.id = blocks.template_id and pt.coach_id = auth.uid()
  )
);

create policy "session templates by linked template" on public.session_templates
for all using (
  exists (
    select 1 from public.blocks b
    join public.program_templates pt on pt.id = b.template_id
    where b.id = session_templates.block_id and pt.coach_id = auth.uid()
  )
);

create policy "session exercises by linked template" on public.session_exercises
for all using (
  exists (
    select 1 from public.session_templates st
    join public.blocks b on b.id = st.block_id
    join public.program_templates pt on pt.id = b.template_id
    where st.id = session_exercises.session_template_id and pt.coach_id = auth.uid()
  )
);

create policy "set prescriptions by linked template" on public.set_prescriptions
for all using (
  exists (
    select 1 from public.session_exercises se
    join public.session_templates st on st.id = se.session_template_id
    join public.blocks b on b.id = st.block_id
    join public.program_templates pt on pt.id = b.template_id
    where se.id = set_prescriptions.session_exercise_id and pt.coach_id = auth.uid()
  )
);

create policy "assignment coach insert/read + client read own" on public.program_assignments
for select using (
  client_id = auth.uid()
  or exists (
    select 1 from public.program_templates pt
    where pt.id = template_id and pt.coach_id = auth.uid()
  )
);

create policy "assignment coach write" on public.program_assignments
for insert with check (
  created_by = auth.uid()
  and exists (select 1 from public.program_templates pt where pt.id = template_id and pt.coach_id = auth.uid())
);

create policy "instances client own or coach linked" on public.session_instances
for select using (
  client_id = auth.uid()
  or exists (
    select 1 from public.coach_client_links ccl where ccl.coach_id = auth.uid() and ccl.client_id = session_instances.client_id
  )
);

create policy "instances coach insert/update" on public.session_instances
for all using (
  exists (
    select 1 from public.coach_client_links ccl where ccl.coach_id = auth.uid() and ccl.client_id = session_instances.client_id
  )
);

create policy "set logs client own + coach linked read" on public.set_logs
for select using (
  exists (
    select 1 from public.session_instances si
    where si.id = set_logs.session_instance_id and (
      si.client_id = auth.uid()
      or exists (select 1 from public.coach_client_links ccl where ccl.coach_id = auth.uid() and ccl.client_id = si.client_id)
    )
  )
);

create policy "set logs client write own" on public.set_logs
for insert with check (
  exists (
    select 1 from public.session_instances si
    where si.id = set_logs.session_instance_id and si.client_id = auth.uid()
  )
);

create policy "feedback access linked" on public.session_feedback
for all using (
  exists (
    select 1 from public.session_instances si
    where si.id = session_feedback.session_instance_id and (
      si.client_id = auth.uid()
      or exists (select 1 from public.coach_client_links ccl where ccl.coach_id = auth.uid() and ccl.client_id = si.client_id)
    )
  )
);
