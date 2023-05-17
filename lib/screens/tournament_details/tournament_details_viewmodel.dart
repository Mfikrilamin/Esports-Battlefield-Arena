import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/organizer.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/models/user.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/utils/date.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TournamentDetailViewModel extends FutureViewModel<void> {
  final AppRouter _router = locator<AppRouter>();
  final Database _database = locator<Database>();
  final Auth _auth = locator<Auth>();
  bool _isOrganizer = false;

  // getter
  bool get isOrganizer => _isOrganizer;

  Future<String> getOrganizerName(String id) async {
    Organizer _organizer = Organizer.fromJson(
        await _database.get(id, FirestoreCollections.organizer));
    return _organizer.organizerName;
  }

  Future<void> registerTournament(Tournament tournament) async {
    setBusy(true);
    await Future.delayed(const Duration(seconds: 1));
    setBusy(false);
    _router.push(TournamentRegistrationRoute(tournament: tournament));
  }

  Future<void> getUserRole() async {
    User user = User.fromJson(
        await _database.get(_auth.currentUser()!, FirestoreCollections.users));
    if (user.role == UserRole.organizer.name) {
      _isOrganizer = true;
    } else {
      _isOrganizer = false;
    }
    notifyListeners();
  }

  @override
  Future<void> futureToRun() {
    getUserRole();
    return Future.value();
  }
}
