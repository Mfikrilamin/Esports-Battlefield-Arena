import 'package:esports_battlefield_arena/app/route.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/services/signup/signup_service.dart';
import 'package:esports_battlefield_arena/utils/regex_validation_helper.dart';
import 'package:stacked/stacked.dart';

class SignUpViewModel extends ReactiveViewModel {
  final AppRouter _router = locator<AppRouter>();
  final log = locator<LogService>();

  //State of the viewmodel
  final _signUpViewModelService = locator<SignUpViewModelService>();
  bool _emailValid = false;
  bool _isSignUp = false;

  //Getters
  String get email => _signUpViewModelService.email;
  String get password => _signUpViewModelService.password;
  String get country => _signUpViewModelService.country;
  bool get isPlayer => _signUpViewModelService.isPlayer;
  bool get isEmailValid => _emailValid;
  bool get isSignUpSucess => _isSignUp;

  void updateEmail(String email) {
    _emailValid = RegexValidation.validateEmail(email);
    _signUpViewModelService.updateEmail(email);
  }

  void updatePassword(String password) {
    _signUpViewModelService.updatePassword(password);
  }

  void updateCountry(String country, String? countryCode) {
    _signUpViewModelService.updateCountry(country);
  }

  void updateAddress(String address) {
    _signUpViewModelService.updateAddress(address);
  }

  void updateFirstName(String firstName) {
    _signUpViewModelService.updateFirstName(firstName);
  }

  void updateLastName(String lastName) {
    _signUpViewModelService.updateLastName(lastName);
  }

  void updateOrganization(String organization) {
    _signUpViewModelService.updateOrganization(organization);
  }

  void navigateToSignInPage() {
    //reset the state of viewmodel
    _signUpViewModelService.reset();
    _router.popUntilRoot();
    _router.push(const SignInRoute());
  }

  void navigateToSignInNextPage() {
    if (_emailValid) {
      _router.push(const SignUpNextRoute());
    }
  }

  void navigatetoPreviousPage() {
    //need to reset the firstname,lastname and organization
    _signUpViewModelService.updateFirstName('');
    _signUpViewModelService.updateLastName('');
    _signUpViewModelService.updateOrganization('');
    _router.pop();
  }

  void updateIsPlayer(bool bool) {
    _signUpViewModelService.updateIsPlayer(bool);
    notifyListeners();
  }

  Future processSignUp() async {
    final currentPath = _router.current.path;
    log.debug(
        // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
        'Email: ${_signUpViewModelService.email} \n' +
            'Password: ${_signUpViewModelService.password} \n' +
            'Country: ${_signUpViewModelService.country} \n' +
            'adress: ${_signUpViewModelService.address} \n' +
            'firstName: ${_signUpViewModelService.firstName} \n' +
            'lastName: ${_signUpViewModelService.lastName} \n' +
            'organization: ${_signUpViewModelService.organization} \n' +
            'isPlayer: ${_signUpViewModelService.isPlayer}}');
    setBusy(true);
    await Future.delayed(const Duration(seconds: 3));
    setBusy(false);
    _isSignUp = true;
    await Future.delayed(const Duration(seconds: 2));
    _isSignUp = false;
    notifyListeners();
    //check if the current path is the same as the path before the delay
    //if it is the same, then navigate to the next page
    //Otherwise, do nothing since the user navigated to another page
    //This is prevent confuse to the user
    if (!isBusy && _router.current.path == currentPath) {
      _router.push(const TestingRoute());
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_signUpViewModelService];
}
