import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/service.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:stacked/stacked.dart';

class NicknameVerificationViewModel extends BaseViewModel {
  final AppRouter _router = locator<AppRouter>();
  final Database _database = locator<Database>();
  final log = locator<LogService>();
  final Auth _auth = locator<Auth>();
  final LogService _log = locator<LogService>();

  //State of the view
  String _username = '';
  String _apexUsername = '';
  String _valorantUsername = '';
  String _valorantTagline = '';
  String _platformSelected = '';
  int _platformSelectedIndex = 0;

  //Permanent Variables
  List<String> platformList =
      ApexLegendPlatform.values.map((e) => e.name).toList();

  //getters
  String get username => _username;
  String get apexUsername => _apexUsername;
  String get valorantUsername => _valorantUsername;
  String get valorantTagline => _valorantTagline;
  String get platformSelected => _platformSelected;
  int get platformSelectedIndex => _platformSelectedIndex;

  void updateUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void updateApexUsername(String username) {
    _apexUsername = username;
    notifyListeners();
  }

  void updateValorantUsername(String username) {
    _valorantUsername = username;
    notifyListeners();
  }

  void updateValorantTagline(String tagline) {
    _valorantTagline = tagline;
    notifyListeners();
  }

  void updateSelectedPlatformIndex(int? value) {
    if (value == null) return;
    _platformSelectedIndex = value;
    _platformSelected = platformList[value];
    notifyListeners();
  }

  verifyUsernameInformation(String email) {}
}
