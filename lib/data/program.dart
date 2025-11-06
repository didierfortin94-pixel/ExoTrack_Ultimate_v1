
import 'exercise.dart';

class SetPrescription {
  final int reps;
  final double? percent1Rm;
  final double? targetVelocity;
  final double? rpe;
  final int restSec;
  final String? tempo;
  const SetPrescription({required this.reps, this.percent1Rm, this.targetVelocity, this.rpe, required this.restSec, this.tempo});
}

class Block {
  final Exercise exercise;
  final int blocks;
  final int microSets;
  final int intraSetRestSec;
  final int interBlockRestSec;
  final SetPrescription base;
  const Block({required this.exercise, required this.blocks, required this.microSets, required this.intraSetRestSec, required this.interBlockRestSec, required this.base});
}

class SessionPlan {
  final String id;
  final String name;
  final List<Block> blocks;
  final DateTime plannedAt;
  const SessionPlan({required this.id, required this.name, required this.blocks, required this.plannedAt});
}

class ProgramWeek {
  final int weekIndex;
  final List<SessionPlan> sessions;
  final String focus;
  const ProgramWeek({required this.weekIndex, required this.sessions, required this.focus});
}

class SetLog {
  final String exerciseId;
  final int reps;
  final double? loadKg;
  final double? meanVelocity;
  final double? power;
  final Duration rest;
  const SetLog({required this.exerciseId, required this.reps, this.loadKg, this.meanVelocity, this.power, required this.rest});
}
