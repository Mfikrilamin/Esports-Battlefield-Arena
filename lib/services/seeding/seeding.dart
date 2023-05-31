import 'package:esports_battlefield_arena/models/tournament.dart';

abstract class Seeding {
  Future<void> generateMatchForSingleElimination(
      Tournament tournament, int gamePerMatch);
  Future<void> generateMatchForApex(Tournament tournament);
  Future<bool> seedTeamsForSingleElimination(Tournament tournament);
  Future<bool> seedTeamsForApex(Tournament tournament);
}
