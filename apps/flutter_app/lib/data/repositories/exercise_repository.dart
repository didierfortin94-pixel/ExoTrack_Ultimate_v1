import 'package:coachpulse/data/models/exercise.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExerciseRepository {
  ExerciseRepository(this._client);

  final SupabaseClient _client;

  Future<List<Exercise>> listForCoach(String coachId) async {
    final response = await _client
        .from('exercises')
        .select()
        .eq('coach_id', coachId)
        .order('name');
    return response.map(Exercise.fromJson).toList();
  }
}
