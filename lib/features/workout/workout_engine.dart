
import 'dart:async';
import '../../data/program.dart';
import '../sensors/ble_manager.dart';

enum WorkoutMode { planned, sensor }
enum WorkoutPhase { idle, warmup, main, finished }

class WorkoutEngine {
  final BleManager ble;
  final _events = StreamController<String>.broadcast();
  WorkoutMode mode = WorkoutMode.planned;
  WorkoutPhase phase = WorkoutPhase.idle;
  Stream<String> get events => _events.stream;
  WorkoutEngine(this.ble);

  Future<void> start(SessionPlan plan) async { phase = WorkoutPhase.warmup; _events.add('Warm-up started for '+plan.name); }
  Future<void> startWithPolar() async { await ble.connectPolarH10(); _events.add('Polar H10 connected'); }
  void finish(){ phase = WorkoutPhase.finished; _events.add('Session finished'); ble.disconnect(); }
}
