
import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../coach/generator.dart';
import '../coach/yaml_loader.dart';
import '../../data/user_profile.dart';
import '../../data/program.dart';
import '../workout/ui/start_workout_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ExoTrack')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(child: ListTile(leading: const Icon(Icons.show_chart, color: ExoTheme.blue), title: const Text("Charge d'entraînement"), trailing: const Text('672 BON', style: TextStyle(fontSize: 24)))),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final user = UserProfile(id: 'u1', displayName: 'Didier', age: 30, primaryGoal: Goal.power, sports: ['basketball'], experience: Experience.advanced, sessionsPerWeek: 2, equipment: ['DB','Bands','Rack'], oneRm: {'back_squat': 140.0}, limitations: ['ankle_mobility'], seasonPhase: 'in_season');
                final gen = CoachGenerator(CoachYamlLoader());
                final week = await gen.generateWeek(user, const ReadinessPack(score: 72, acwr: 1.05, components: {}));
                if (!context.mounted) return;
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => StartWorkoutPage(week: week)));
              },
              child: const Text('DÉMARRER UNE SÉANCE'),
            ),
          ],
        ),
      ),
    );
  }
}
