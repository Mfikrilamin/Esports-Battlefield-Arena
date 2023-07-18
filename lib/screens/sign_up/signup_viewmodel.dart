import 'package:esports_battlefield_arena/app/app.dart';
import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/models/User.dart';
import 'package:esports_battlefield_arena/models/organizer.dart';
import 'package:esports_battlefield_arena/models/player.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/services/viewmodel_shared_data/signup_service.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:esports_battlefield_arena/utils/regex_validation_helper.dart';
import 'package:stacked/stacked.dart';

class SignUpViewModel extends ReactiveViewModel {
  final AppRouter _router = locator<AppRouter>();
  final Database _database = locator<Database>();
  final Auth _auth = locator<Auth>();
  final log = locator<LogService>();

  // Data of the view
  final _signUpViewModelService = locator<SignUpViewModelService>();

  //State of the view
  bool _emailValid = false;
  bool _isSignUp = false;

  //Getters
  String get email => _signUpViewModelService.email;
  String get password => _signUpViewModelService.password;
  String get country => _signUpViewModelService.country;
  bool get isPlayer => _signUpViewModelService.isPlayer;
  bool get isEmailValid => _emailValid;
  bool get isSignUpSucess => _isSignUp;

  //Setters
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

  void updateIsPlayer(bool bool) {
    _signUpViewModelService.updateIsPlayer(bool);
    notifyListeners();
  }

  // Business Logic
  Future processSignUp() async {
    try {
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

      //register player or organization
      String? currentUserId = await _auth.createAccount(
          _signUpViewModelService.email, _signUpViewModelService.password);

      //if the user is created, then create the player or organization
      //save in the database
      if (currentUserId != null) {
        log.debug('User created with id: $currentUserId');
        // Create a new user
        User newUser = User(
          userId: currentUserId,
          email: _signUpViewModelService.email,
          country: _signUpViewModelService.country,
          address: _signUpViewModelService.address,
          password: _signUpViewModelService.password,
          role: isPlayer ? UserRole.player.name : UserRole.organizer.name,
        );
        await _database.add(newUser.toJson(), FirestoreCollections.users);
        if (isPlayer) {
          //createPlayer
          Player newPlayer = Player(
              userId: currentUserId,
              firstName: _signUpViewModelService.firstName,
              lastName: _signUpViewModelService.lastName);

          await _database.add(newPlayer.toJson(), FirestoreCollections.player);
        } else {
          //createOrganization
          Organizer newOrganizer = Organizer(
              userId: currentUserId,
              organizerName: _signUpViewModelService.organization);
          await _database.add(
              newOrganizer.toJson(), FirestoreCollections.organizer);
        }
      }
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
        //reset the state of viewmodel
        _signUpViewModelService.reset();
        _router.popUntilRoot();
        _router.push(const SignInRoute());
      }
    } on Failure catch (e) {
      setBusy(false);
      _isSignUp = false;
      setError(e.message);
      notifyListeners();
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_signUpViewModelService];

  // Navigation
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
}
