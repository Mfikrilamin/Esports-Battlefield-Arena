import 'package:esports_battlefield_arena/app/app.dart';
import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/services/seeding/seeding.dart';
import 'package:esports_battlefield_arena/services/viewmodel_shared_data/tournament_service.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/utils/date.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateTournamentViewModel extends ReactiveViewModel {
  final AppRouter _router = locator<AppRouter>();
  final _log = locator<LogService>();
  final AppRouter _appRouter = locator<AppRouter>();
  final Auth _auth = locator<Auth>();
  final Database _database = locator<Database>();
  final _tournamentService = locator<TournamentService>();
  final Seeding _seedingAlgorithm = locator<Seeding>();

  //Permanent Variables
  final List<String> _gameList = GameType.values.map((e) => e.name).toList();
  final List<String> _participationTypeList =
      ParticipationType.values.map((e) => e.name).toList();

  List<String> get gameList => _gameList;
  List<String> get participationTypeList => _participationTypeList;

  //getter
  String get title => _tournamentService.title;
  String get description => _tournamentService.description;
  double get prizePool => _tournamentService.prizePool;
  double get entryFee => _tournamentService.entryFee;
  DateTime? get startDate => _tournamentService.startDate;
  DateTime? get endDate => _tournamentService.endDate;
  int get gameSelectedIndex => _tournamentService.gameSelectedIndex;
  int get modeSelectedIndex => _tournamentService.modeSelectedIndex;
  int get maxParticipant => _tournamentService.maxParticipant;
  int get gamePerMatch => _tournamentService.gamePerMatch;
  int get memberPerTeam => _tournamentService.memberPerTeam;
  List<String> get ruleList => _tournamentService.ruleList;

  //share state
  bool get editFlag => _tournamentService.editFlag;

  //setters
  void updateTournamentTitle(String title) {
    _tournamentService.updateTournamentTitle(title);
  }

  void updateTournamentDescription(String description) {
    _tournamentService.updateTournamentDescription(description);
  }

  void updateTournamentPrizePool(String prizePool) {
    if (prizePool.isEmpty) return;
    _tournamentService.updateTournamentPrizePool(prizePool);
  }

  void updateTournamentFee(String fee) {
    _tournamentService.updateTournamentFee(fee);
  }

  void updateStartDate(DateTime selectedDate) {
    _tournamentService.updateStartDate(selectedDate);
  }

  void updateEndDate(DateTime selectedDate) {
    _tournamentService.updateEndDate(selectedDate);
  }

  void updateGameSelectedIndex(int? index) {
    if (index == 0) {
      _tournamentService.updateModeSelectedIndex(1);
    }
    _tournamentService.updateGameSelectedIndex(index);

    notifyListeners();
  }

  void updateModeSelectedIndex(int? index) {
    _tournamentService.updateModeSelectedIndex(index);
    notifyListeners();
  }

  void updateMaxParticipants(String maxParticipant) {
    _tournamentService.updateMaxParticipant(maxParticipant);
  }

  void updateMemberPerTeam(String maxMember) {
    _tournamentService.updateMemberPerTeam(maxMember);
  }

  void updateGamePerMatch(String gamePerMatch) {
    _tournamentService.updateGamePerMatch(gamePerMatch);
  }

  void updateTournamentRule(String rule, int index) {
    _tournamentService.updateRule(rule, index);
  }

  void addNewRule() {
    _tournamentService.addRule();
  }

  void removeRule(int index) {
    _tournamentService.removeRule(index);
  }

  //navigation
  void navigateToPreviousPage() {
    _tournamentService.disposeTournament();
    notifyListeners();
    _router.pop();
  }

  //Business Logic
  Future<void> processTournamentData(BuildContext context) async {
    try {
      setBusy(true);
      _log.info(
          'Title : $title \n Description : $description \n Prize Pool : $prizePool \n Entry Fee : $entryFee \n Start Date : $startDate \n End Date : $endDate \n Game : ${_gameList[gameSelectedIndex]} \n Mode : ${_participationTypeList[modeSelectedIndex]} \n Max Participant : $maxParticipant \n Member Per Team : $memberPerTeam \n Rule : $ruleList');
      if (isInputFieldFilled(context)) {
        if (!gameInputValidation(context)) {
          setBusy(false);
          return;
        }
      } else {
        setBusy(false);
        return;
      }

      Tournament tournament = Tournament(
        tournamentId: editFlag ? _tournamentService.tournamentId : '',
        title: title,
        rules: ruleList,
        description: description,
        prizePool: prizePool,
        entryFee: entryFee,
        startDate: DateHelper.formatDate(startDate!),
        endDate: DateHelper.formatDate(endDate!),
        maxParticipants: maxParticipant,
        maxMemberPerTeam: memberPerTeam,
        gamePerMatch: gamePerMatch,
        game: _gameList[gameSelectedIndex],
        status: GameStatus.pending.name,
        matchList: [],
        organizerId: _auth.currentUser()!,
        currentParticipant: [],
        isSolo: _participationTypeList[modeSelectedIndex] == 'solo',
      );

      if (editFlag) {
        await _database.update(_tournamentService.tournamentId,
            tournament.toJson(), FirestoreCollections.tournament);
      } else {
        String? tournamentId = await _database.add(
            tournament.toJson(), FirestoreCollections.tournament);
        //Reassign new object tournament together with the newly created Id
        tournament = Tournament(
          tournamentId: tournamentId!,
          title: title,
          rules: ruleList,
          description: description,
          prizePool: prizePool,
          entryFee: entryFee,
          startDate: DateHelper.formatDate(startDate!),
          endDate: DateHelper.formatDate(endDate!),
          maxParticipants: maxParticipant,
          maxMemberPerTeam: memberPerTeam,
          gamePerMatch: gamePerMatch,
          game: _gameList[gameSelectedIndex],
          status: GameStatus.pending.name,
          matchList: [],
          organizerId: _auth.currentUser()!,
          currentParticipant: [],
          isSolo: _participationTypeList[modeSelectedIndex] == 'solo',
        );
        if (tournament.game == GameType.Valorant.name) {
          _seedingAlgorithm.generateMatchForSingleElimination(
              tournament, gamePerMatch);
        } else {
          _seedingAlgorithm.generateMatchForApex(tournament);
        }
      }
      setBusy(false);
      // ignore: use_build_context_synchronously
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: kcPrimaryDarkerColor,
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(editFlag
                        ? "Update sucessfully"
                        : "Register sucessfully"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      _tournamentService.disposeTournament();
      _appRouter.popAndPush(const HomeRoute());
    } on Failure catch (failure) {
      _log.debug(failure.toString());
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    color: kcTertiaryColor,
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(failure.message!),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } on Exception catch (e) {
      _log.debug(e.toString());
    } catch (e) {
      _log.debug(e.toString());
      _log.debug(e.runtimeType.toString());
    } finally {
      setBusy(false);
    }
  }

  bool gameInputValidation(BuildContext context) {
    if (gameList[gameSelectedIndex] == GameType.ApexLegend.name) {
      return apexGameValidation(context);
    } else {
      // Check member per team should be 5 only.
      return valorantGameValidation(context);
    }
  }

  bool valorantGameValidation(BuildContext context) {
    if (memberPerTeam != 5) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    color: kcTertiaryColor,
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(editFlag
                        ? "Update failed, member per team should be 5 only"
                        : "Register failed, member per team should be 5 only"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      return false;
    }
    if (gamePerMatch != 3 && gamePerMatch != 1) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    color: kcTertiaryColor,
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(editFlag
                        ? "Update failed, game per match should be 1 or 3 only"
                        : "Register failed, game per match should be 1 or 3 only"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      return false;
    }
    return true;
  }

  bool apexGameValidation(BuildContext context) {
    // Check member per team should be 1 or 3 only.
    // Check max participant should be increment of 20
    if (maxParticipant % 20 != 0) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    color: kcTertiaryColor,
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(editFlag
                        ? "Update failed, max participant should be increment of 20"
                        : "Register failed, max participant should be increment of 20"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      return false;
    }
    if (participationTypeList[modeSelectedIndex] ==
        ParticipationType.solo.name) {
      // if game is apex and the mode is solo, member per team should be only 1
      if (memberPerTeam != 1) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error,
                      color: kcTertiaryColor,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(editFlag
                          ? "Update failed, member per team should be 1 only"
                          : "Register failed, member per team should be 1 only"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        return false;
      }
    } else {
      //if mode the game is team and the mode is team, the member per team should be 3
      if (memberPerTeam != 3) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error,
                      color: kcTertiaryColor,
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(editFlag
                          ? "Update failed, member per team should be 3 only"
                          : "Register failed, member per team should be 3 only"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        return false;
      }
    }
    return true;
  }

  bool isInputFieldFilled(BuildContext context) {
    if (startDate == null ||
        endDate == null ||
        startDate!.isAfter(endDate!) ||
        title.isEmpty ||
        description.isEmpty ||
        prizePool == 0 ||
        entryFee == 0 ||
        maxParticipant == 0 ||
        memberPerTeam == 0 ||
        (ruleList.length == 1 && ruleList[0].isEmpty)) {
      //show error dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    color: kcTertiaryColor,
                  ),
                  SizedBox(
                    width: 200,
                    child: Text(editFlag
                        ? "Update failed, please fill in all details"
                        : "Register failed, please fill in all details"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_tournamentService];
}
