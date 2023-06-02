// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i19;
import 'package:esports_battlefield_arena/models/tournament.dart' as _i22;
import 'package:esports_battlefield_arena/screens/create_tournament/create_tournament_view.dart'
    as _i1;
import 'package:esports_battlefield_arena/screens/home/home_view.dart' as _i2;
import 'package:esports_battlefield_arena/screens/main_home/main_home_view.dart'
    as _i3;
import 'package:esports_battlefield_arena/screens/my_organized_tournament.dart/my_organized_tournament_view.dart'
    as _i4;
import 'package:esports_battlefield_arena/screens/nickname_verification/nickname_verification_view.dart'
    as _i5;
import 'package:esports_battlefield_arena/screens/participant_view/participants_information_view.dart'
    as _i6;
import 'package:esports_battlefield_arena/screens/payment_history/payment_history_view.dart'
    as _i7;
import 'package:esports_battlefield_arena/screens/player_registered_tournament/player_registered_tournament_view.dart'
    as _i8;
import 'package:esports_battlefield_arena/screens/profile/profile_view.dart'
    as _i9;
import 'package:esports_battlefield_arena/screens/register_tournament/tournament_registration_view.dart'
    as _i10;
import 'package:esports_battlefield_arena/screens/sign_in/signin_view.dart'
    as _i11;
import 'package:esports_battlefield_arena/screens/sign_up/sign_up_next_screen.dart'
    as _i13;
import 'package:esports_battlefield_arena/screens/sign_up/signup_screen.dart'
    as _i12;
import 'package:esports_battlefield_arena/screens/testing/testing_view.dart'
    as _i14;
import 'package:esports_battlefield_arena/screens/tournament_details/tournament_details_view.dart'
    as _i15;
import 'package:esports_battlefield_arena/screens/view_leaderboard/leadboard_view.dart'
    as _i16;
import 'package:esports_battlefield_arena/screens/view_leaderboard/leaderboard_edit_view.dart'
    as _i17;
import 'package:esports_battlefield_arena/screens/view_organized_tournament/organized_tournament__detailview.dart'
    as _i18;
import 'package:esports_battlefield_arena/utils/enum.dart' as _i21;
import 'package:flutter/material.dart' as _i20;

abstract class $AppRouter extends _i19.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i19.PageFactory> pagesMap = {
    CreateTournamentRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.CreateTournamentView(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomeView(),
      );
    },
    MainHomeRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.MainHomeView(),
      );
    },
    MyOrganizedTournamentRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.MyOrganizedTournamentView(),
      );
    },
    NicknameVerificationRoute.name: (routeData) {
      final args = routeData.argsAs<NicknameVerificationRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.NicknameVerificationView(
          key: args.key,
          emailList: args.emailList,
          gameType: args.gameType,
        ),
      );
    },
    ParticipantInformationRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ParticipantInformationView(),
      );
    },
    PaymentHistoryRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.PaymentHistoryView(),
      );
    },
    PlayerRegisteredTournamentRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.PlayerRegisteredTournamentView(),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.ProfileView(),
      );
    },
    TournamentRegistrationRoute.name: (routeData) {
      final args = routeData.argsAs<TournamentRegistrationRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.TournamentRegistrationView(
          key: args.key,
          tournament: args.tournament,
        ),
      );
    },
    SignInRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SignInView(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SignUpView(),
      );
    },
    SignUpNextRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.SignUpNextView(),
      );
    },
    TestingRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.TestingView(),
      );
    },
    TournamentDetailRoute.name: (routeData) {
      final args = routeData.argsAs<TournamentDetailRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.TournamentDetailView(
          key: args.key,
          tournament: args.tournament,
        ),
      );
    },
    LeaderboardRoute.name: (routeData) {
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.LeaderboardView(),
      );
    },
    EditLeaderboardRoute.name: (routeData) {
      final args = routeData.argsAs<EditLeaderboardRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i17.EditLeaderboardView(
          key: args.key,
          roundIndex: args.roundIndex,
          matchIndex: args.matchIndex,
          matchResultIndex: args.matchResultIndex,
        ),
      );
    },
    OrganizedTournamentDetailRoute.name: (routeData) {
      final args = routeData.argsAs<OrganizedTournamentDetailRouteArgs>();
      return _i19.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i18.OrganizedTournamentDetailView(
          key: args.key,
          tournament: args.tournament,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.CreateTournamentView]
class CreateTournamentRoute extends _i19.PageRouteInfo<void> {
  const CreateTournamentRoute({List<_i19.PageRouteInfo>? children})
      : super(
          CreateTournamentRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateTournamentRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i2.HomeView]
class HomeRoute extends _i19.PageRouteInfo<void> {
  const HomeRoute({List<_i19.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i3.MainHomeView]
class MainHomeRoute extends _i19.PageRouteInfo<void> {
  const MainHomeRoute({List<_i19.PageRouteInfo>? children})
      : super(
          MainHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainHomeRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i4.MyOrganizedTournamentView]
class MyOrganizedTournamentRoute extends _i19.PageRouteInfo<void> {
  const MyOrganizedTournamentRoute({List<_i19.PageRouteInfo>? children})
      : super(
          MyOrganizedTournamentRoute.name,
          initialChildren: children,
        );

  static const String name = 'MyOrganizedTournamentRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i5.NicknameVerificationView]
class NicknameVerificationRoute
    extends _i19.PageRouteInfo<NicknameVerificationRouteArgs> {
  NicknameVerificationRoute({
    _i20.Key? key,
    required List<String> emailList,
    required _i21.GameType gameType,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          NicknameVerificationRoute.name,
          args: NicknameVerificationRouteArgs(
            key: key,
            emailList: emailList,
            gameType: gameType,
          ),
          initialChildren: children,
        );

  static const String name = 'NicknameVerificationRoute';

  static const _i19.PageInfo<NicknameVerificationRouteArgs> page =
      _i19.PageInfo<NicknameVerificationRouteArgs>(name);
}

class NicknameVerificationRouteArgs {
  const NicknameVerificationRouteArgs({
    this.key,
    required this.emailList,
    required this.gameType,
  });

  final _i20.Key? key;

  final List<String> emailList;

  final _i21.GameType gameType;

  @override
  String toString() {
    return 'NicknameVerificationRouteArgs{key: $key, emailList: $emailList, gameType: $gameType}';
  }
}

/// generated route for
/// [_i6.ParticipantInformationView]
class ParticipantInformationRoute extends _i19.PageRouteInfo<void> {
  const ParticipantInformationRoute({List<_i19.PageRouteInfo>? children})
      : super(
          ParticipantInformationRoute.name,
          initialChildren: children,
        );

  static const String name = 'ParticipantInformationRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i7.PaymentHistoryView]
class PaymentHistoryRoute extends _i19.PageRouteInfo<void> {
  const PaymentHistoryRoute({List<_i19.PageRouteInfo>? children})
      : super(
          PaymentHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'PaymentHistoryRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i8.PlayerRegisteredTournamentView]
class PlayerRegisteredTournamentRoute extends _i19.PageRouteInfo<void> {
  const PlayerRegisteredTournamentRoute({List<_i19.PageRouteInfo>? children})
      : super(
          PlayerRegisteredTournamentRoute.name,
          initialChildren: children,
        );

  static const String name = 'PlayerRegisteredTournamentRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i9.ProfileView]
class ProfileRoute extends _i19.PageRouteInfo<void> {
  const ProfileRoute({List<_i19.PageRouteInfo>? children})
      : super(
          ProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i10.TournamentRegistrationView]
class TournamentRegistrationRoute
    extends _i19.PageRouteInfo<TournamentRegistrationRouteArgs> {
  TournamentRegistrationRoute({
    _i20.Key? key,
    required _i22.Tournament tournament,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          TournamentRegistrationRoute.name,
          args: TournamentRegistrationRouteArgs(
            key: key,
            tournament: tournament,
          ),
          initialChildren: children,
        );

  static const String name = 'TournamentRegistrationRoute';

  static const _i19.PageInfo<TournamentRegistrationRouteArgs> page =
      _i19.PageInfo<TournamentRegistrationRouteArgs>(name);
}

class TournamentRegistrationRouteArgs {
  const TournamentRegistrationRouteArgs({
    this.key,
    required this.tournament,
  });

  final _i20.Key? key;

  final _i22.Tournament tournament;

  @override
  String toString() {
    return 'TournamentRegistrationRouteArgs{key: $key, tournament: $tournament}';
  }
}

/// generated route for
/// [_i11.SignInView]
class SignInRoute extends _i19.PageRouteInfo<void> {
  const SignInRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SignUpView]
class SignUpRoute extends _i19.PageRouteInfo<void> {
  const SignUpRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i13.SignUpNextView]
class SignUpNextRoute extends _i19.PageRouteInfo<void> {
  const SignUpNextRoute({List<_i19.PageRouteInfo>? children})
      : super(
          SignUpNextRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpNextRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i14.TestingView]
class TestingRoute extends _i19.PageRouteInfo<void> {
  const TestingRoute({List<_i19.PageRouteInfo>? children})
      : super(
          TestingRoute.name,
          initialChildren: children,
        );

  static const String name = 'TestingRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i15.TournamentDetailView]
class TournamentDetailRoute
    extends _i19.PageRouteInfo<TournamentDetailRouteArgs> {
  TournamentDetailRoute({
    _i20.Key? key,
    required _i22.Tournament tournament,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          TournamentDetailRoute.name,
          args: TournamentDetailRouteArgs(
            key: key,
            tournament: tournament,
          ),
          initialChildren: children,
        );

  static const String name = 'TournamentDetailRoute';

  static const _i19.PageInfo<TournamentDetailRouteArgs> page =
      _i19.PageInfo<TournamentDetailRouteArgs>(name);
}

class TournamentDetailRouteArgs {
  const TournamentDetailRouteArgs({
    this.key,
    required this.tournament,
  });

  final _i20.Key? key;

  final _i22.Tournament tournament;

  @override
  String toString() {
    return 'TournamentDetailRouteArgs{key: $key, tournament: $tournament}';
  }
}

/// generated route for
/// [_i16.LeaderboardView]
class LeaderboardRoute extends _i19.PageRouteInfo<void> {
  const LeaderboardRoute({List<_i19.PageRouteInfo>? children})
      : super(
          LeaderboardRoute.name,
          initialChildren: children,
        );

  static const String name = 'LeaderboardRoute';

  static const _i19.PageInfo<void> page = _i19.PageInfo<void>(name);
}

/// generated route for
/// [_i17.EditLeaderboardView]
class EditLeaderboardRoute
    extends _i19.PageRouteInfo<EditLeaderboardRouteArgs> {
  EditLeaderboardRoute({
    _i20.Key? key,
    required int roundIndex,
    required int matchIndex,
    required int matchResultIndex,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          EditLeaderboardRoute.name,
          args: EditLeaderboardRouteArgs(
            key: key,
            roundIndex: roundIndex,
            matchIndex: matchIndex,
            matchResultIndex: matchResultIndex,
          ),
          initialChildren: children,
        );

  static const String name = 'EditLeaderboardRoute';

  static const _i19.PageInfo<EditLeaderboardRouteArgs> page =
      _i19.PageInfo<EditLeaderboardRouteArgs>(name);
}

class EditLeaderboardRouteArgs {
  const EditLeaderboardRouteArgs({
    this.key,
    required this.roundIndex,
    required this.matchIndex,
    required this.matchResultIndex,
  });

  final _i20.Key? key;

  final int roundIndex;

  final int matchIndex;

  final int matchResultIndex;

  @override
  String toString() {
    return 'EditLeaderboardRouteArgs{key: $key, roundIndex: $roundIndex, matchIndex: $matchIndex, matchResultIndex: $matchResultIndex}';
  }
}

/// generated route for
/// [_i18.OrganizedTournamentDetailView]
class OrganizedTournamentDetailRoute
    extends _i19.PageRouteInfo<OrganizedTournamentDetailRouteArgs> {
  OrganizedTournamentDetailRoute({
    _i20.Key? key,
    required _i22.Tournament tournament,
    List<_i19.PageRouteInfo>? children,
  }) : super(
          OrganizedTournamentDetailRoute.name,
          args: OrganizedTournamentDetailRouteArgs(
            key: key,
            tournament: tournament,
          ),
          initialChildren: children,
        );

  static const String name = 'OrganizedTournamentDetailRoute';

  static const _i19.PageInfo<OrganizedTournamentDetailRouteArgs> page =
      _i19.PageInfo<OrganizedTournamentDetailRouteArgs>(name);
}

class OrganizedTournamentDetailRouteArgs {
  const OrganizedTournamentDetailRouteArgs({
    this.key,
    required this.tournament,
  });

  final _i20.Key? key;

  final _i22.Tournament tournament;

  @override
  String toString() {
    return 'OrganizedTournamentDetailRouteArgs{key: $key, tournament: $tournament}';
  }
}
