import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/User.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends FutureViewModel<void> {
  final AppRouter _router = locator<AppRouter>();
  final log = locator<LogService>();
  int _selectedIndex = 0;
  AppRouter _appRouter = locator<AppRouter>();
  Auth _auth = locator<Auth>();
  Database _database = locator<Database>();
  LogService _log = locator<LogService>();
  bool isPlayer = false;

  int get selectedIndex => _selectedIndex;

  void onNavigateBarTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> currentUserIsPlayer() async {
    String? userId = await _auth.currentUser()!;
    if (userId == null) {
      //redirect to sign in
      _router.popUntil((route) => route.settings.name == SignInRoute.name);
    }
    User user =
        User.fromJson(await _database.get(userId, FirestoreCollections.users));
    if (user.role == UserRole.player.name) {
      isPlayer = true;
    } else {
      isPlayer = false;
    }
    _log.debug(UserRole.player.name);
    _log.debug('isPlayer : $isPlayer');
    notifyListeners();
  }

  @override
  Future<void> futureToRun() => currentUserIsPlayer();
}
