
enum Goal { maintenance, power, strength, powerEndurance, fatLoss, aerobic }
enum Experience { novice, intermediate, advanced }

class UserProfile {
  final String id;
  final String displayName;
  final int age;
  final Goal primaryGoal;
  final List<String> sports;
  final Experience experience;
  final int sessionsPerWeek;
  final List<String> equipment;
  final Map<String, double> oneRm;
  final List<String> limitations;
  final String seasonPhase; // transition, off, pre, in, taper
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.age,
    required this.primaryGoal,
    required this.sports,
    required this.experience,
    required this.sessionsPerWeek,
    required this.equipment,
    required this.oneRm,
    required this.limitations,
    required this.seasonPhase,
  });
}
