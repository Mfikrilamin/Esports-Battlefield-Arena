import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final AppRouter _router = locator<AppRouter>();
  final log = locator<LogService>();
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void onNavigateBarTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
