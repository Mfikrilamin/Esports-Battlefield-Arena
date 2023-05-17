import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/screens/home/home_viewmodel.dart';
import 'package:esports_battlefield_arena/screens/main_home/main_home_viewmodel.dart';
import 'package:esports_battlefield_arena/screens/profile/profile_viewmodel.dart';
import 'package:esports_battlefield_arena/screens/sign_in/signin_viewmodel.dart';
import 'package:esports_battlefield_arena/screens/sign_up/signup_viewmodel.dart';
import 'package:esports_battlefield_arena/services/counter/counter_service.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/fireauth_service.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/database/firestore_service.dart';
import 'package:esports_battlefield_arena/services/initializer/service_initializer.dart';
import 'package:esports_battlefield_arena/services/initializer/service_initializer_firebase.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/services/payment/stripe.dart';
import 'package:esports_battlefield_arena/services/payment/stripe_service.dart';
import 'package:esports_battlefield_arena/services/signup/signup_service.dart';
import 'package:esports_battlefield_arena/services/viewmodel_shared_data/tournament_service.dart';
import 'package:map_mvvm/service_locator.dart';
import 'package:stacked_services/stacked_services.dart';

final locator = ServiceLocator.locator;

Future<void> initializeServiceLocator() async {
  // In case of using Firebase services, Firebase must be initialized first before the service locator,
  //  because viewmodels may need to access firebase during the creation of the objects.

  // To comply with Dependency Inversion, the Firebase.initializeApp() is called in a dedicated service file.
  //  So that, if you want to change to different services (other than Firebase), you can do so by simply
  //  defining another ServiceInitializer class.

  // Register first and then run immediately
  locator.registerLazySingleton<ServiceInitializer>(
      () => ServiceInitializerImpl());

  //inialize firebase
  final serviceInitializer = locator<ServiceInitializer>();
  await serviceInitializer.init();

  // Services
  locator.registerLazySingleton<Database>(() => FirestoreService());
  locator.registerLazySingleton<Auth>(() => FireAuthService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AppRouter());
  locator.registerLazySingleton(() => LogService());
  locator.registerLazySingleton<Payment>(() => StripePaymentService());

  //viewmodel
  locator.registerLazySingleton(() => SignUpViewModel());
  locator.registerLazySingleton(() => SignInViewModel());
  locator.registerLazySingleton(() => HomeViewModel());
  locator.registerLazySingleton(() => MainHomeViewModel());
  locator.registerLazySingleton(() => ProfileViewModel());

  //viewmodelservice
  locator.registerLazySingleton(() => CounterService());
  locator.registerLazySingleton(() => TournamentService());
  locator.registerLazySingleton(() => SignUpViewModelService());
}
