import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/organizer.dart';
import 'package:esports_battlefield_arena/models/player.dart';
import 'package:esports_battlefield_arena/models/user.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/services/payment/stripe.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends FutureViewModel<void> {
  final AppRouter _router = locator<AppRouter>();
  Payment _StripeService = locator<Payment>();
  final _log = locator<LogService>();
  final Database _database = locator<Database>();
  final Auth _auth = locator<Auth>();

  User user = User();
  Player player = Player();
  Organizer organizer = Organizer();

  String _email = '';
  String _password = '';
  String _address = '';
  String _country = '';
  String _firstName = '';
  String _lastName = '';
  String _organization = '';
  bool _isPlayer = true;
  bool _isUpdateSucess = false;

  //Getters
  bool get isPlayer => _isPlayer;
  String get email => _email;
  String get password => _password;
  String get address => _address;
  String get country => _country;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get organization => _organization;

  bool get isUpdateSuccess => _isUpdateSucess;

  void updateEmail(String email) {
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

  Future<void> updateProfileInformation() async {
    try {
      setBusy(true);
      User user = User(
        userId: _auth.currentUser()!,
        email: _email,
        address: _address,
        country: _country,
        password: _password,
        role: _isPlayer ? UserRole.player.name : UserRole.organizer.name,
      );
      //update in the database
      await _database.update(
          _auth.currentUser()!, user.toJson(), FirestoreCollections.users);

      if (isPlayer) {
        Player player = Player(
          userId: _auth.currentUser()!,
          firstName: _firstName,
          lastName: _lastName,
        );
        await _database.update(
            _auth.currentUser()!, player.toJson(), FirestoreCollections.player);
      } else {
        Organizer organizer = Organizer(
          userId: _auth.currentUser()!,
          organizerName: _organization,
        );
        await _database.update(_auth.currentUser()!, organizer.toJson(),
            FirestoreCollections.organizer);
      }
      setBusy(false);
      _isUpdateSucess = true;
      await Future.delayed(const Duration(seconds: 2), () {
        _isUpdateSucess = false;
        notifyListeners();
      });
    } catch (e) {
      _log.debug(e.toString());
    }
  }

  @override
  Future<void> futureToRun() async {
    try {
      //to decide whether to show player or organizer profile
      String userId = _auth.currentUser()!;
      user = User.fromJson(
          await _database.get(userId, FirestoreCollections.users));
      _log.info('User: $user');
      _email = user.email;
      _password = user.password;
      _address = user.address;
      _country = user.country;
      if (user.role == UserRole.player.name) {
        _isPlayer = true;
        player = Player.fromJson(
            await _database.get(userId, FirestoreCollections.player));
        _log.info('Player: $player');
        _firstName = player.firstName;
        _lastName = player.lastName;
      } else {
        _isPlayer = false;
        organizer = Organizer.fromJson(
            await _database.get(userId, FirestoreCollections.organizer));
        _log.info('Organizer: $organizer');
        _organization = organizer.organizerName;
      }
    } catch (e) {
      _log.debug(e.toString());
    }
    return Future.value();
  }

  void logout() async {
    //Sign out user
    await _StripeService.clearAllPaymentSheet();
    await _auth.signOut();
    //pop all the screens and navigate to sign in screen
    _router.popUntil((route) => route.settings.name == SignInRoute.name);
  }
}
