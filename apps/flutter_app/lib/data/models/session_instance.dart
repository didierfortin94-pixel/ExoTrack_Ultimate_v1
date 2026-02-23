enum SessionStatus { scheduled, inProgress, completed, skipped }

class SessionInstance {
  const SessionInstance({
    required this.id,
    required this.assignmentId,
    required this.date,
    required this.name,
    this.status = SessionStatus.scheduled,
  });

  final String id;
  final String assignmentId;
  final DateTime date;
  final String name;
  final SessionStatus status;
}
