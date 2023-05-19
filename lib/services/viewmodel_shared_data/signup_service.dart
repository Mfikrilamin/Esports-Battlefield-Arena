
import 'package:stacked/stacked.dart';
// import 'package:observable_ish/observable_ish.dart';

class SignUpViewModelService with ReactiveServiceMixin {
  SignUpViewModelService() {
    listenToReactiveValues([
      _isPlayer,
      _email,
      _password,
      _address,
      _country,
      _firstName,
      _lastName,
      _organization
    ]);
  }
  ReactiveValue<String> _email = ReactiveValue<String>('');
  ReactiveValue<String> _password = ReactiveValue<String>('');
  ReactiveValue<String> _address = ReactiveValue<String>('');
  ReactiveValue<String> _country = ReactiveValue<String>('');
  ReactiveValue<String> _firstName = ReactiveValue<String>('');
  ReactiveValue<String> _lastName = ReactiveValue<String>('');
  ReactiveValue<String> _organization = ReactiveValue<String>('');
  ReactiveValue<bool> _isPlayer = ReactiveValue<bool>(true);

  //getters
  bool get isPlayer => _isPlayer.value;
  String get email => _email.value;
  String get password => _password.value;
  String get country => _country.value;
  String get address => _address.value;
  String get firstName => _firstName.value;
  String get lastName => _lastName.value;
  String get organization => _organization.value;

  void updateIsPlayer(bool isPlayer) {
    _isPlayer.value = isPlayer;
  }

  void updateEmail(String email) {
    _email.value = email;
  }

  void updatePassword(String password) {
    _password.value = password;
  }

  void updateCountry(String country) {
    _country.value = country;
  }

  void updateAddress(String address) {
    _address.value = address;
  }

  void updateFirstName(String firstName) {
    _firstName.value = firstName;
  }

  void updateLastName(String lastName) {
    _lastName.value = lastName;
  }

  void updateOrganization(String organization) {
    _organization.value = organization;
  }

  void reset() {
    _isPlayer.value = true;
    _email.value = '';
    _password.value = '';
    _address.value = '';
    _country.value = '';
    _firstName.value = '';
    _lastName.value = '';
    _organization.value = '';
  }
}
