import 'package:coachpulse/data/models/exercise.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Exercise JSON round-trip', () {
    const exercise = Exercise(
      id: 'ex-1',
      coachId: 'coach-1',
      name: 'Back squat',
      category: ExerciseCategory.strength,
      equipment: 'Barbell',
      instructions: 'Stay braced',
      coachingCues: ['knees out'],
    );

    final json = exercise.toJson();
    final restored = Exercise.fromJson(json);

    expect(restored.name, 'Back squat');
    expect(restored.category, ExerciseCategory.strength);
  });
}
