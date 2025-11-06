
import 'package:flutter/material.dart';
import '../../../data/program.dart';
import '../../sensors/ble_manager.dart';
import '../workout_engine.dart';

class StartWorkoutPage extends StatefulWidget {
  final ProgramWeek week;
  const StartWorkoutPage({super.key, required this.week});
  @override
  State<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  late final BleManager ble = BleManager();
  late final WorkoutEngine engine = WorkoutEngine(ble);
  late final SessionPlan session = widget.week.sessions.first;
  String eventText = ''; int lastBpm = 0;

  @override
  void initState() {
    super.initState();
    engine.events.listen((e) { if (mounted) setState(() => eventText = e); });
    ble.heartRate.listen((bpm) { if (mounted) setState(() => lastBpm = bpm); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(session.name)), body: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$lastBpm bpm (Polar H10)'), const SizedBox(height: 8),
      ElevatedButton(onPressed: () => engine.startWithPolar(), child: const Text('Connecter Polar H10')),
      const SizedBox(height: 8),
      ElevatedButton(onPressed: () => engine.start(session), child: const Text('Démarrer la séance')),
      const SizedBox(height: 8),
      Text(eventText, style: const TextStyle(color: Colors.white70)),
    ])));
  }
}
