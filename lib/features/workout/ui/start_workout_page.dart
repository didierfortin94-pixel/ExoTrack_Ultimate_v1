import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/program.dart';
import '../../sensors/ble_manager.dart';
import '../workout_engine.dart';

class StartWorkoutPage extends StatefulWidget {
  const StartWorkoutPage({super.key, required this.week});

  final ProgramWeek week;

  @override
  State<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  late final BleManager ble = BleManager();
  late final WorkoutEngine engine = WorkoutEngine(ble);
  late final SessionPlan session;

  StreamSubscription<String>? _eventSubscription;
  StreamSubscription<int>? _heartRateSubscription;
  StreamSubscription<SensorState>? _sensorSubscription;

  String eventText = 'Prêt à démarrer';
  int lastBpm = 0;
  bool _isConnectingPolar = false;
  SensorState _sensorState = SensorState.off;

  @override
  void initState() {
    super.initState();
    if (widget.week.sessions.isEmpty) {
      throw StateError('ProgramWeek.sessions ne peut pas être vide');
    }
    session = widget.week.sessions.first;
    _sensorState = ble.currentState;

    _eventSubscription = engine.events.listen((event) {
      if (!mounted) return;
      setState(() => eventText = event);
    });

    _heartRateSubscription = ble.heartRate.listen((bpm) {
      if (!mounted) return;
      setState(() => lastBpm = bpm);
    });

    _sensorSubscription = ble.state.listen((state) {
      if (!mounted) return;
      setState(() => _sensorState = state);
    });
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _heartRateSubscription?.cancel();
    _sensorSubscription?.cancel();
    unawaited(engine.finish());
    unawaited(engine.dispose());
    unawaited(ble.dispose());
    super.dispose();
  }

  Future<void> _connectPolar() async {
    setState(() {
      _isConnectingPolar = true;
      eventText = 'Connexion au Polar H10…';
    });

    final connected = await engine.startWithPolar();
    if (!mounted) return;

    setState(() {
      _isConnectingPolar = false;
      eventText = connected ? 'Polar H10 connecté' : 'Polar H10 introuvable';
    });
  }

  Future<void> _startSession() async {
    await engine.start(session);
    if (!mounted) return;
    setState(() {
      eventText = 'Séance démarrée';
    });
  }

  String get _sensorStateLabel {
    switch (_sensorState) {
      case SensorState.off:
        return 'Capteur inactif';
      case SensorState.scanning:
        return 'Recherche de capteurs…';
      case SensorState.connecting:
        return 'Connexion en cours…';
      case SensorState.ready:
        return 'Polar prêt';
      case SensorState.streaming:
        return 'Streaming en direct';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bpmText = lastBpm > 0 ? '$lastBpm bpm' : '--- bpm';

    return Scaffold(
      appBar: AppBar(title: Text(session.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_sensorStateLabel, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(bpmText, style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isConnectingPolar ? null : _connectPolar,
              child: _isConnectingPolar
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                  : const Text('Connecter Polar H10'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _startSession, child: const Text('Démarrer la séance')),
            const SizedBox(height: 16),
            Text(eventText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
