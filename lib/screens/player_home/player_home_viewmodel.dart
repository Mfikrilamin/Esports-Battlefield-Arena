import 'package:esports_battlefield_arena/app/route.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:stacked/stacked.dart';

class PlayerHomeViewModel extends BaseViewModel {
  final AppRouter _router = locator<AppRouter>();
  final log = locator<LogService>();
  double _top = 0.00;
  double get top => _top;
  void updateTop(double value) {
    _top = value;
    // notifyListeners();
  }
}
