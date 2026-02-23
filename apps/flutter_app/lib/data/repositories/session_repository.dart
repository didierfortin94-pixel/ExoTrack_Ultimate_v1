import 'package:coachpulse/data/models/session_instance.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionRepository {
  SessionRepository(this._client);

  final SupabaseClient _client;

  Future<List<SessionInstance>> weekSessions(String clientId) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final end = start.add(const Duration(days: 7));
    final response = await _client
        .from('session_instances')
        .select('id, assignment_id, date, status, session_templates(name)')
        .eq('client_id', clientId)
        .gte('date', start.toIso8601String())
        .lt('date', end.toIso8601String())
        .order('date');
    return response
        .map(
          (raw) => SessionInstance(
            id: raw['id'] as String,
            assignmentId: raw['assignment_id'] as String,
            date: DateTime.parse(raw['date'] as String),
            name: (raw['session_templates']?['name'] ?? 'Session') as String,
            status: _statusFromDb(raw['status'] as String),
          ),
        )
        .toList();
  }
}

SessionStatus _statusFromDb(String value) {
  return switch (value) {
    'scheduled' => SessionStatus.scheduled,
    'completed' => SessionStatus.completed,
    'skipped' => SessionStatus.skipped,
    _ => SessionStatus.inProgress,
  };
}
