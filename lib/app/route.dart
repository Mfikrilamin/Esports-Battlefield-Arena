import 'package:auto_route/annotations.dart';
import 'package:esports_battlefield_arena/screens/Example/example.dart';
import 'package:esports_battlefield_arena/screens/future_example/future_example_view.dart';
import 'package:esports_battlefield_arena/screens/home/home_view.dart';
import 'package:esports_battlefield_arena/screens/partial_build_view/partial_build_view.dart';
import 'package:esports_battlefield_arena/screens/reactive_example/reactive_build_view.dart';
import 'package:esports_battlefield_arena/screens/profile/profile_view.dart';
import 'package:esports_battlefield_arena/screens/sign_in/signin_view.dart';
import 'package:esports_battlefield_arena/screens/sign_up/sign_up_next_screen.dart';
import 'package:esports_battlefield_arena/screens/sign_up/signup_screen.dart';
import 'package:esports_battlefield_arena/screens/stream_example/stream_example_view.dart';
import 'package:esports_battlefield_arena/screens/testing/testing_viewmodel.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'View,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomeView, initial: true),
    AutoRoute(page: SignInView),
    AutoRoute(page: PartialBuildsView),
    AutoRoute(page: ReactiveView),
    AutoRoute(page: FutureExampleView),
    AutoRoute(page: StreamExampleView),
    AutoRoute(page: ExampleView),
    AutoRoute(page: TestingView),
    AutoRoute(page: SignUpView),
    AutoRoute(page: SignUpNextView),
    AutoRoute(page: ProfileView),
  ],
)
class $AppRouter {}
