// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:esports_battlefield_arena/models/tournament.dart' as _i13;
import 'package:esports_battlefield_arena/screens/home/home_view.dart' as _i1;
import 'package:esports_battlefield_arena/screens/payment_history/payment_history_view.dart'
    as _i10;
import 'package:esports_battlefield_arena/screens/player_home/player_home_view.dart'
    as _i2;
import 'package:esports_battlefield_arena/screens/profile/profile_view.dart'
    as _i3;
import 'package:esports_battlefield_arena/screens/register_tournament/tournament_registration_view.dart'
    as _i4;
import 'package:esports_battlefield_arena/screens/sign_in/signin_view.dart'
    as _i5;
import 'package:esports_battlefield_arena/screens/sign_up/sign_up_next_screen.dart'
    as _i7;
import 'package:esports_battlefield_arena/screens/sign_up/signup_screen.dart'
    as _i6;
import 'package:esports_battlefield_arena/screens/testing/testing_view.dart'
    as _i8;
import 'package:esports_battlefield_arena/screens/tournament_details/tournament_details_view.dart'
    as _i9;
import 'package:flutter/material.dart' as _i12;

abstract class $AppRouter extends _i11.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i11.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeView(),
      );
    },
    PlayerHomeRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.PlayerHomeView(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.ProfileView(),
      );
    },
    TournamentRegistrationRoute.name: (routeData) {
      final args = routeData.argsAs<TournamentRegistrationRouteArgs>();
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.TournamentRegistrationView(
          key: args.key,
          tournament: args.tournament,
        ),
      );
    },
    SignInRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.SignInView(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SignUpView(),
      );
    },
    SignUpNextRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.SignUpNextView(),
      );
    },
    TestingRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.TestingView(),
      );
    },
    TournamentDetailRoute.name: (routeData) {
      final args = routeData.argsAs<TournamentDetailRouteArgs>();
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i9.TournamentDetailView(
          key: args.key,
          tournament: args.tournament,
        ),
      );
    },
    PaymentHistoryRoute.name: (routeData) {
      return _i11.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.PaymentHistoryView(),
      );
    },
  };
}

/// generated route for
/// [_i1.HomeView]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute({List<_i11.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i2.PlayerHomeView]
class PlayerHomeRoute extends _i11.PageRouteInfo<void> {
  const PlayerHomeRoute({List<_i11.PageRouteInfo>? children})
      : super(
          PlayerHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'PlayerHomeRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ProfileView]
class ProfileRoute extends _i11.PageRouteInfo<void> {
  const ProfileRoute({List<_i11.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i4.TournamentRegistrationView]
class TournamentRegistrationRoute
    extends _i11.PageRouteInfo<TournamentRegistrationRouteArgs> {
  TournamentRegistrationRoute({
    _i12.Key? key,
    required _i13.Tournament tournament,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          TournamentRegistrationRoute.name,
          args: TournamentRegistrationRouteArgs(
            key: key,
            tournament: tournament,
          ),
          initialChildren: children,
        );

  static const String name = 'TournamentRegistrationRoute';

  static const _i11.PageInfo<TournamentRegistrationRouteArgs> page =
      _i11.PageInfo<TournamentRegistrationRouteArgs>(name);
}

class TournamentRegistrationRouteArgs {
  const TournamentRegistrationRouteArgs({
    this.key,
    required this.tournament,
  });

  final _i12.Key? key;

  final _i13.Tournament tournament;

  @override
  String toString() {
    return 'TournamentRegistrationRouteArgs{key: $key, tournament: $tournament}';
  }
}

/// generated route for
/// [_i5.SignInView]
class SignInRoute extends _i11.PageRouteInfo<void> {
  const SignInRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i6.SignUpView]
class SignUpRoute extends _i11.PageRouteInfo<void> {
  const SignUpRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SignUpNextView]
class SignUpNextRoute extends _i11.PageRouteInfo<void> {
  const SignUpNextRoute({List<_i11.PageRouteInfo>? children})
      : super(
          SignUpNextRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpNextRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i8.TestingView]
class TestingRoute extends _i11.PageRouteInfo<void> {
  const TestingRoute({List<_i11.PageRouteInfo>? children})
      : super(
          TestingRoute.name,
          initialChildren: children,
        );

  static const String name = 'TestingRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}

/// generated route for
/// [_i9.TournamentDetailView]
class TournamentDetailRoute
    extends _i11.PageRouteInfo<TournamentDetailRouteArgs> {
  TournamentDetailRoute({
    _i12.Key? key,
    required _i13.Tournament tournament,
    List<_i11.PageRouteInfo>? children,
  }) : super(
          TournamentDetailRoute.name,
          args: TournamentDetailRouteArgs(
            key: key,
            tournament: tournament,
          ),
          initialChildren: children,
        );

  static const String name = 'TournamentDetailRoute';

  static const _i11.PageInfo<TournamentDetailRouteArgs> page =
      _i11.PageInfo<TournamentDetailRouteArgs>(name);
}

class TournamentDetailRouteArgs {
  const TournamentDetailRouteArgs({
    this.key,
    required this.tournament,
  });

  final _i12.Key? key;

  final _i13.Tournament tournament;

  @override
  String toString() {
    return 'TournamentDetailRouteArgs{key: $key, tournament: $tournament}';
  }
}

/// generated route for
/// [_i10.PaymentHistoryView]
class PaymentHistoryRoute extends _i11.PageRouteInfo<void> {
  const PaymentHistoryRoute({List<_i11.PageRouteInfo>? children})
      : super(
          PaymentHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'PaymentHistoryRoute';

  static const _i11.PageInfo<void> page = _i11.PageInfo<void>(name);
}
