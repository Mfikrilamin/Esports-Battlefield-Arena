import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:flutter/material.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  final List<AutoRoute> routes = [
    //HomeScreen is generated as HomeRoute because
    //of the replaceInRouteName property
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: MainHomeRoute.page),
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: SignInRoute.page, path: '/'),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: SignUpNextRoute.page),
    AutoRoute(page: TestingRoute.page),
    // AutoRoute(page: TournamentDetailRoute.page, ),
    CustomRoute(
      durationInMilliseconds: 500,
      reverseDurationInMilliseconds: 500,
      page: TournamentDetailRoute.page,
      transitionsBuilder: ((BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: const Interval(0, 0.5));
        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
        // you get an animation object and a widget
        // make your own transition
      }),
    ),
    CustomRoute(
      durationInMilliseconds: 500,
      reverseDurationInMilliseconds: 500,
      page: TournamentRegistrationRoute.page,
      transitionsBuilder: ((BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: const Interval(0.5, 1.0));
        return SharedAxisTransition(
          //  fillColor: Theme.of(context).cardColor,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
        // you get an animation object and a widget
        // make your own transition
      }),
    ),
    AutoRoute(page: PaymentHistoryRoute.page),
    // AutoRoute(page: RegisteredTournament.page),
  ];
}
