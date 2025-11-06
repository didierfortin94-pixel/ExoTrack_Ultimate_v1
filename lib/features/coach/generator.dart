
import '../../data/user_profile.dart';
import '../../data/program.dart';
import '../../data/exercise.dart';
import 'yaml_loader.dart';

class ReadinessPack {
  final double score; final double acwr; final Map<String,double> components;
  const ReadinessPack({required this.score, required this.acwr, required this.components});
}

class CoachGenerator {
  final CoachYamlLoader loader; CoachGenerator(this.loader);

  Future<ProgramWeek> generateWeek(UserProfile user, ReadinessPack ready) async {
    final primarySport = user.sports.first;
    final rules = await loader.load(primarySport);
    final phase = user.seasonPhase;
    final weekly = rules.data['phases'][phase]['weekly_mix'] as Map;
    final focus = weekly.entries.map((e)=>'${e.key} ${(e.value*100).round()}%').join(' / ');
    final templates = rules.data['templates'] as Map;
    final main = templates['power_session']['main'][0] as Map;
    final exTags = List<String>.from(main['exercise_tags']);
    final ex = Exercise(id: exTags.join('_'), name: 'Auto • '+exTags.first, tags: exTags, loadType: '%1RM', youtubeUrl: null);
    final pres = SetPrescription(reps: 1, percent1Rm: 0.5, targetVelocity: 0.9, restSec: 15);
    final block = Block(exercise: ex, blocks: 4, microSets: 6, intraSetRestSec: 15, interBlockRestSec: 180, base: pres);
    final s1 = SessionPlan(id: 's1', name: 'Power A', blocks: [block], plannedAt: DateTime.now());
    final s2 = SessionPlan(id: 's2', name: 'Power B', blocks: [block], plannedAt: DateTime.now().add(const Duration(days:3)));
    return ProgramWeek(weekIndex: 1, sessions: [s1,s2], focus: focus);
  }
}
