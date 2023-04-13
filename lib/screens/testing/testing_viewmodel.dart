import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:stacked/stacked.dart';

class TestingViewModel extends BaseViewModel {
  final AppRouter _router = locator<AppRouter>();
  String _title = 'Testing page';
  int _counter = 0;

  int get counter => _counter;
  String get title => '$_title $_counter';

  void navigateToSignIn() {
    _router.push(const SignInRoute());
  }

  void navigateToPreviousPage() {
    _router.pop();
  }
}
