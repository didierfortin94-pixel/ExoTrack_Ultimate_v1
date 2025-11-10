import 'dart:async';

import '../../data/program.dart';
import '../sensors/ble_manager.dart';

enum WorkoutMode { planned, sensor }
enum WorkoutPhase { idle, warmup, main, finished }

class WorkoutEngine {
  WorkoutEngine(this.ble);

  final BleManager ble;
  final _events = StreamController<String>.broadcast();

  WorkoutMode mode = WorkoutMode.planned;
  WorkoutPhase phase = WorkoutPhase.idle;

  Stream<String> get events => _events.stream;

  Future<void> start(SessionPlan plan) async {
    mode = WorkoutMode.planned;
    phase = WorkoutPhase.warmup;
    _events.add('Échauffement lancé pour ${plan.name}');
  }

  Future<bool> startWithPolar() async {
    mode = WorkoutMode.sensor;
    final connected = await ble.connectPolarH10();
    if (connected) {
      _events.add('Polar H10 connecté');
    } else {
      _events.add('Polar H10 introuvable');
    }
    return connected;
  }

  Future<void> finish() async {
    phase = WorkoutPhase.finished;
    _events.add('Séance terminée');
    await ble.disconnect();
  }

  Future<void> dispose() async {
    await _events.close();
  }
}
