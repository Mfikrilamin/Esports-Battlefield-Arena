import 'package:esports_battlefield_arena/app/app.dart';
import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/utils/regex_validation_helper.dart';
import 'package:stacked/stacked.dart';

class SignInViewModel extends FutureViewModel<void> {
  final log = locator<LogService>();
  final AppRouter _router = locator<AppRouter>();
  final Auth _auth = locator<Auth>();

  String _email = '';
  String _password = '';
  bool emailValid = false;
  bool _isSignIn = false;
  bool _hasError = false;

  String get email => _email;
  String get password => _password;
  bool get isSignInSucess => _isSignIn;
  @override
  bool get hasError => _hasError;

  void updateEmail(String email) {
    emailValid = RegexValidation.validateEmail(email);
    _email = email;
    notifyListeners();
  }

  void updatePassword(String password) {
    _password = password;
  }

  Future processSignIn() async {
    try {
      final currentPath = _router.current.path;
      log.debug('Email: $_email \nPassword: $_password');
      if (emailValid) {
        setBusy(true);
        String? userId = await _auth.signIn(_email, _password);
        log.debug('User Id: $userId');
        setBusy(false);
        if (userId == null) {
          setError('Invalid email or password');
          _hasError = true;
          setBusy(false);
          notifyListeners();
          return;
        }
        _isSignIn = true;
        if (_router.current.path == currentPath && isBusy == false) {
          _isSignIn = false;
          notifyListeners();
          _router.push(const HomeRoute());
        }
      }
    } on Failure catch (e) {
      log.debug(e.toString());
      _hasError = true;
      notifyListeners();
    }
  }

  void navigateToSignUpPage() {
    _router.push(const SignUpRoute());
  }

  resetViewModelState() {
    _email = '';
    _password = '';
    emailValid = false;
    _isSignIn = false;
    _hasError = false;
  }

  void clearErrorMessage() {
    setBusy(false);
    _hasError = false;
    notifyListeners();
  }

  @override
  Future<void> futureToRun() {
    bool isLogin = _auth.isUserSignOn();
    if (isLogin) {
      _router.push(const HomeRoute());
    }
    return Future.value();
  }
}
