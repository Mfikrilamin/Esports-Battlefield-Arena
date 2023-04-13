import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/utils/regex_validation_helper.dart';
import 'package:stacked/stacked.dart';

class SignInViewModel extends BaseViewModel {
  final log = locator<LogService>();
  final AppRouter _router = locator<AppRouter>();

  String _email = '';
  String _password = '';
  bool emailValid = false;
  bool _isSignIn = false;

  String get email => _email;
  String get password => _password;
  bool get isSignInSucess => _isSignIn;

  void updateEmail(String email) {
    emailValid = RegexValidation.validateEmail(email);
    _email = email;
    notifyListeners();
  }

  void updatePassword(String password) {
    _password = password;
  }

  Future processSignIn() async {
    final currentPath = _router.current.path;
    log.debug('Email: $_email \nPassword: $_password');
    if (emailValid) {
      setBusy(true);
      await Future.delayed(const Duration(seconds: 2));
      setBusy(false);
      _isSignIn = true;
      await Future.delayed(const Duration(seconds: 2));
      if (_router.current.path == currentPath && isBusy == false) {
        _isSignIn = false;
        notifyListeners();
        _router.push(const HomeRoute());
      }
    }
  }

  void navigateToSignUpPage() {
    _router.push(const SignUpRoute());
  }
}
