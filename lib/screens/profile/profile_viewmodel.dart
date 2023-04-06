import 'package:esports_battlefield_arena/app/route.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/utils/regex_validation_helper.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  final AppRouter _router = locator<AppRouter>();
  final log = locator<LogService>();

  String _email = 'Initial Email';
  String _password = 'Initial Password';
  String _address = 'Initial Address';
  String _country = 'Malaysia';
  String _firstName = 'My First Nane';
  String _lastName = 'My Last Name';
  String _organization = 'Esport Club Of UTM';
  bool _isPlayer = true;
  bool _isEmailValid = false;

  //getters
  String get country => _country;
  String get email => _email;
  String get password => _password;
  String get address => _address;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get organization => _organization;
  bool get isPlayer => _isPlayer;

  get isEmailValid => _isEmailValid;

  void updateEmail(String email) {
    _isEmailValid = RegexValidation.validateEmail(email);
    _email = email;
    notifyListeners();
  }

  void updatePassword(String password) {
    _password = password;
    // notifyListeners();q
  }

  void updateAddress(String address) {
    _address = address;
    // notifyListeners();
  }

  void updateCountry(String name, String countryCode) {
    _country = name;
    // notifyListeners();
  }

  void updateFirstName(String firstName) {
    _firstName = firstName;
    // notifyListeners();
  }

  void updateLastName(String lastName) {
    _lastName = lastName;
    // notifyListeners();
  }

  void updateOrganization(String organization) {
    _organization = organization;
    // notifyListeners();
  }
}
