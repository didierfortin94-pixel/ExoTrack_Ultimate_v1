-- Demo identifiers: replace with real auth.users UUIDs in your project
insert into public.profiles (user_id, role, display_name)
values
('11111111-1111-1111-1111-111111111111', 'COACH', 'Coach Demo'),
('22222222-2222-2222-2222-222222222222', 'CLIENT', 'Client Demo')
on conflict do nothing;

insert into public.coach_client_links (coach_id, client_id, invite_code)
values ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'CP-DEMO-001')
on conflict do nothing;

insert into public.exercises (coach_id, name, category, equipment, instructions, coaching_cues, tags)
values
('11111111-1111-1111-1111-111111111111', 'Back Squat', 'strength', 'Barbell', 'Brace and descend under control.', '{"knees out","drive up"}', '{"lower"}'),
('11111111-1111-1111-1111-111111111111', 'Romanian Deadlift', 'strength', 'Barbell', 'Hinge hips with neutral spine.', '{"hips back","lats on"}', '{"posterior"}'),
('11111111-1111-1111-1111-111111111111', 'Box Jump', 'plyo', 'Plyo box', 'Explode and stick landing.', '{"soft landing"}', '{"power"}'),
('11111111-1111-1111-1111-111111111111', 'Bike Intervals', 'conditioning', 'Bike', '30s hard / 60s easy.', '{"maintain cadence"}', '{"conditioning"}'),
('11111111-1111-1111-1111-111111111111', 'Ankle Mobility', 'mobility', 'Band', 'Controlled dorsiflexion.', '{"slow reps"}', '{"rehab"}');
