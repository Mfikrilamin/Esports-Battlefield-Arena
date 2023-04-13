import 'package:country_picker/country_picker.dart';
import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/utils/regex_validation_helper.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TournamentRegistrationViewModel extends BaseViewModel {
  final AppRouter _router = locator<AppRouter>();
  final log = locator<LogService>();

  //Email Controller
  List<String> _emailController = [];

  //state
  String _teamName = '';
  String _teamCountry = '';

  //Apex Player state

  //Valorant Player state
  String player1Email = '';
  String player2Email = '';
  String player3Email = '';
  String player4Email = '';
  String player5Email = '';

  //getter
  String get getTeamName => _teamName;
  get getTeamCountry => _teamCountry;

  void updateTeamName(String teamName) {
    _teamName = teamName;
    // notifyListeners();
  }

  void updateTeamCountry(String countryName, String countryCode) {
    _teamCountry = countryName;
    // notifyListeners();
  }

  void updatePlayerEmail(String email, int index) {
    _emailController[index] = email;
    print('index $index: ${_emailController[index]}');
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.clear();
  }

  void setPlayerEmailController(String game, isSolo) {
    switch (game) {
      case 'ApexLegend':
        _emailController = ['', '', ''];
        if (isSolo) {
          _emailController = [''];
        }
        break;
      case 'Valorant':
        _emailController = ['', '', '', '', ''];
        break;
      default:
    }
  }
}
