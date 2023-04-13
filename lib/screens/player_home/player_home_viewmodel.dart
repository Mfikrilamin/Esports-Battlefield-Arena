import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/components/widgets/custom_page_route_builder.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/screens/tournament_details/tournament_details_view.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class PlayerHomeViewModel extends BaseViewModel {
  final AppRouter _router = locator<AppRouter>();
  final log = locator<LogService>();

  late BuildContext _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  //sliverAppBar
  double _top = 0.00;
  double get top => _top;

  //Tournament card
  int _selectedIndex = 0;
  bool _isExpanded = false;

  List<String> fakeRules = [
    'Hate speech, offensive behavior, or verbal abuse related to sex, gender identity and expression, sexual orientation, race, ethnicity, disability, physical appearance, body size, age, or religion.',
    'Stalking or intimidation (physically or online).',
    'Spamming, raiding, hijacking, or inciting disruption of streams or social media',
    'Posting or threatening to post other people’s personally identifying information (“doxing”)',
    'Unwelcome sexual attention. This includes, unwelcome sexualized comments, jokes, and sexual advances.',
    'Advocating for, or encouraging, any of the above behavior.',
    'Penalty Points & barrages are given for incidents within ESL-Matches',
    'Exclusion of the offending player from the current tournaments in which they are participating*',
    'Insults or inappropriate behaviour within Comments or other options for contacting a player, will result in a Forum- & Comment ban',
    'Rule 10',
  ];

  final List<Tournament> _tournamentList = [
    Tournament(
      tournamentId: '1',
      title: 'Apex Legend 1',
      description:
          'Apex Legend 1 is a first-person shooter video game developed by EA DICE and published by Electronic Arts. It is the fifteenth installment in the Battlefield series, and the first main entry in the series since Battlefield 4.',
      prizePool: 1000,
      startDate: '2021-01-01',
      endDate: '2021-01-03',
      currentParticipant: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      maxParticipants: 14,
      organizerId: 'User 1',
      isSolo: true,
      rules: [
        'Hate speech, offensive behavior, or verbal abuse related to sex, gender identity and expression, sexual orientation, race, ethnicity, disability, physical appearance, body size, age, or religion.',
        'Stalking or intimidation (physically or online).',
        'Spamming, raiding, hijacking, or inciting disruption of streams or social media',
        'Posting or threatening to post other people’s personally identifying information (“doxing”)',
        'Unwelcome sexual attention. This includes, unwelcome sexualized comments, jokes, and sexual advances.',
        'Advocating for, or encouraging, any of the above behavior.',
        'Penalty Points & barrages are given for incidents within ESL-Matches',
        'Exclusion of the offending player from the current tournaments in which they are participating*',
        'Insults or inappropriate behaviour within Comments or other options for contacting a player, will result in a Forum- & Comment ban',
        'Rule 10',
      ],
      game: GameType.ApexLegend.name,
      maxMemberPerTeam: 0,
    ),
    Tournament(
      tournamentId: '2',
      title: 'Valorant',
      description:
          'Valorant is a free-to-play multiplayer first-person shooter developed and published by Riot Games. Set in the near future, players control one of a number of agents, each with their own unique set of abilities.',
      prizePool: 5000,
      startDate: '2023-05-01',
      endDate: '2023-05-03',
      currentParticipant: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      maxParticipants: 12,
      organizerId: 'User 2',
      isSolo: false,
      rules: [
        'Hate speech, offensive behavior, or verbal abuse related to sex, gender identity and expression, sexual orientation, race, ethnicity, disability, physical appearance, body size, age, or religion.',
        'Stalking or intimidation (physically or online).',
        'Spamming, raiding, hijacking, or inciting disruption of streams or social media',
        'Posting or threatening to post other people’s personally identifying information (“doxing”)',
        'Unwelcome sexual attention. This includes, unwelcome sexualized comments, jokes, and sexual advances.',
        'Advocating for, or encouraging, any of the above behavior.',
        'Penalty Points & barrages are given for incidents within ESL-Matches',
        'Exclusion of the offending player from the current tournaments in which they are participating*',
        'Insults or inappropriate behaviour within Comments or other options for contacting a player, will result in a Forum- & Comment ban',
        'Rule 10',
      ],
      game: GameType.Valorant.name,
      maxMemberPerTeam: 5,
    ),
    Tournament(
      tournamentId: '1',
      title:
          'Apex Legend 1 dasdawd dawdaw dawdawtgae we wedwa dawf awrf dsa dwsad wadaw',
      description:
          'Apex Legend 1 is a first-person shooter video game developed by EA DICE and published by Electronic Arts. It is the fifteenth installment in the Battlefield series, and the first main entry in the series since Battlefield 4.',
      prizePool: 1000,
      startDate: '2021-01-01',
      endDate: '2021-01-03',
      currentParticipant: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      maxParticipants: 14,
      organizerId: 'User 1',
      isSolo: true,
      game: GameType.ApexLegend.name,
      maxMemberPerTeam: 0,
      rules: [
        'Hate speech, offensive behavior, or verbal abuse related to sex, gender identity and expression, sexual orientation, race, ethnicity, disability, physical appearance, body size, age, or religion.',
        'Stalking or intimidation (physically or online).',
        'Spamming, raiding, hijacking, or inciting disruption of streams or social media',
        'Posting or threatening to post other people’s personally identifying information (“doxing”)',
        'Unwelcome sexual attention. This includes, unwelcome sexualized comments, jokes, and sexual advances.',
        'Advocating for, or encouraging, any of the above behavior.',
        'Penalty Points & barrages are given for incidents within ESL-Matches',
        'Exclusion of the offending player from the current tournaments in which they are participating*',
        'Insults or inappropriate behaviour within Comments or other options for contacting a player, will result in a Forum- & Comment ban',
        'Rule 10',
      ],
    ),
    Tournament(
      tournamentId: '2',
      title: 'Valorant',
      description:
          'Valorant is a free-to-play multiplayer first-person shooter developed and published by Riot Games. Set in the near future, players control one of a number of agents, each with their own unique set of abilities.',
      prizePool: 5000,
      startDate: '2023-05-01',
      endDate: '2023-05-03',
      currentParticipant: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      maxParticipants: 12,
      organizerId: 'User 2',
      isSolo: false,
      game: GameType.Valorant.name,
      maxMemberPerTeam: 5,
      rules: [
        'Hate speech, offensive behavior, or verbal abuse related to sex, gender identity and expression, sexual orientation, race, ethnicity, disability, physical appearance, body size, age, or religion.',
        'Stalking or intimidation (physically or online).',
        'Spamming, raiding, hijacking, or inciting disruption of streams or social media',
        'Posting or threatening to post other people’s personally identifying information (“doxing”)',
        'Unwelcome sexual attention. This includes, unwelcome sexualized comments, jokes, and sexual advances.',
        'Advocating for, or encouraging, any of the above behavior.',
        'Penalty Points & barrages are given for incidents within ESL-Matches',
        'Exclusion of the offending player from the current tournaments in which they are participating*',
        'Insults or inappropriate behaviour within Comments or other options for contacting a player, will result in a Forum- & Comment ban',
        'Rule 10',
      ],
    ),
    Tournament(
      tournamentId: '1',
      title: 'Apex Legend 1',
      description:
          'Apex Legend 1 is a first-person shooter video game developed by EA DICE and published by Electronic Arts. It is the fifteenth installment in the Battlefield series, and the first main entry in the series since Battlefield 4.',
      prizePool: 1000,
      startDate: '2021-01-01',
      endDate: '2021-01-03',
      currentParticipant: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      maxParticipants: 14,
      organizerId: 'User 1',
      isSolo: true,
      game: GameType.ApexLegend.name,
      maxMemberPerTeam: 0,
      rules: [
        'Hate speech, offensive behavior, or verbal abuse related to sex, gender identity and expression, sexual orientation, race, ethnicity, disability, physical appearance, body size, age, or religion.',
        'Stalking or intimidation (physically or online).',
        'Spamming, raiding, hijacking, or inciting disruption of streams or social media',
        'Posting or threatening to post other people’s personally identifying information (“doxing”)',
        'Unwelcome sexual attention. This includes, unwelcome sexualized comments, jokes, and sexual advances.',
        'Advocating for, or encouraging, any of the above behavior.',
        'Penalty Points & barrages are given for incidents within ESL-Matches',
        'Exclusion of the offending player from the current tournaments in which they are participating*',
        'Insults or inappropriate behaviour within Comments or other options for contacting a player, will result in a Forum- & Comment ban',
        'Rule 10',
      ],
    ),
    Tournament(
      tournamentId: '2',
      title: 'Valorant',
      description:
          'Valorant is a free-to-play multiplayer first-person shooter developed and published by Riot Games. Set in the near future, players control one of a number of agents, each with their own unique set of abilities.',
      prizePool: 5000,
      startDate: '2023-05-01',
      endDate: '2023-05-03',
      currentParticipant: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      maxParticipants: 12,
      organizerId: 'User 2',
      isSolo: false,
      game: GameType.Valorant.name,
      maxMemberPerTeam: 5,
      rules: [
        'Hate speech, offensive behavior, or verbal abuse related to sex, gender identity and expression, sexual orientation, race, ethnicity, disability, physical appearance, body size, age, or religion.',
        'Stalking or intimidation (physically or online).',
        'Spamming, raiding, hijacking, or inciting disruption of streams or social media',
        'Posting or threatening to post other people’s personally identifying information (“doxing”)',
        'Unwelcome sexual attention. This includes, unwelcome sexualized comments, jokes, and sexual advances.',
        'Advocating for, or encouraging, any of the above behavior.',
        'Penalty Points & barrages are given for incidents within ESL-Matches',
        'Exclusion of the offending player from the current tournaments in which they are participating*',
        'Insults or inappropriate behaviour within Comments or other options for contacting a player, will result in a Forum- & Comment ban',
        'Rule 10',
      ],
    ),
    Tournament(
      tournamentId: '1',
      title: 'Apex Legend 1 dasd wd asd wadswadsa edwadwad',
      description:
          'Apex Legend 1 is a first-person shooter video game developed by EA DICE and published by Electronic Arts. It is the fifteenth installment in the Battlefield series, and the first main entry in the series since Battlefield 4.',
      prizePool: 1000,
      startDate: '2021-01-01',
      endDate: '2021-01-03',
      currentParticipant: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
      maxParticipants: 14,
      organizerId: 'User 1',
      isSolo: true,
      game: GameType.ApexLegend.name,
      maxMemberPerTeam: 0,
      rules: [
        'Hate speech, offensive behavior, or verbal abuse related to sex, gender identity and expression, sexual orientation, race, ethnicity, disability, physical appearance, body size, age, or religion.',
        'Stalking or intimidation (physically or online).',
        'Spamming, raiding, hijacking, or inciting disruption of streams or social media',
        'Posting or threatening to post other people’s personally identifying information (“doxing”)',
        'Unwelcome sexual attention. This includes, unwelcome sexualized comments, jokes, and sexual advances.',
        'Advocating for, or encouraging, any of the above behavior.',
        'Penalty Points & barrages are given for incidents within ESL-Matches',
        'Exclusion of the offending player from the current tournaments in which they are participating*',
        'Insults or inappropriate behaviour within Comments or other options for contacting a player, will result in a Forum- & Comment ban',
        'Rule 10',
      ],
    ),
    Tournament(
      tournamentId: '2',
      title: 'Valorant',
      description:
          'Valorant is a free-to-play multiplayer first-person shooter developed and published by Riot Games. Set in the near future, players control one of a number of agents, each with their own unique set of abilities.',
      prizePool: 5000,
      startDate: '2023-05-01',
      endDate: '2023-05-03',
      maxParticipants: 12,
      organizerId: 'User 2',
      isSolo: false,
      game: GameType.Valorant.name,
      maxMemberPerTeam: 5,
      rules: [
        'Hate speech, offensive behavior, or verbal abuse related to sex, gender identity and expression, sexual orientation, race, ethnicity, disability, physical appearance, body size, age, or religion.',
        'Stalking or intimidation (physically or online).',
        'Spamming, raiding, hijacking, or inciting disruption of streams or social media',
        'Posting or threatening to post other people’s personally identifying information (“doxing”)',
        'Unwelcome sexual attention. This includes, unwelcome sexualized comments, jokes, and sexual advances.',
        'Advocating for, or encouraging, any of the above behavior.',
        'Penalty Points & barrages are given for incidents within ESL-Matches',
        'Exclusion of the offending player from the current tournaments in which they are participating*',
        'Insults or inappropriate behaviour within Comments or other options for contacting a player, will result in a Forum- & Comment ban',
        'Rule 10',
      ],
    )
  ];

  //getters
  int get selectedIndex => _selectedIndex;
  bool get isExpanded => _isExpanded;
  List<Tournament> get tournamentList => _tournamentList;

  //setters
  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void navigateToTournamentDetail(int index) {
    _router.push(TournamentDetailRoute(tournament: _tournamentList[index]));
    // ExtendedNavigator.of(_context)!.push(TournamentDetailRoute(tournament: _tournamentList[index]));

    // ExtendedNavigator.of(_context)!.push(CustomRoute1(name: TournamentDetailRoute.name, page: TournamentDetailRoute.page(tournament: _tournamentList[index])));
    // Navigator.of(_context).push(
    //   PageRouteBuilder(
    //     transitionDuration: Duration(seconds: 1),
    //     reverseTransitionDuration: Duration(seconds: 1),
    //     pageBuilder: (context, animation, secondaryAnimation) {
    //       final curvedAnimation =
    //           CurvedAnimation(parent: animation, curve: Interval(0, 0.5));
    //       return FadeTransition(
    //         opacity: curvedAnimation,
    //         child: TournamentDetailView(
    //           tournament: _tournamentList[index],
    //         ),
    //       );
    //     },
    //   ),
    // );
    // _router.push(TournamentDetailRoute(tournament: _tournamentList[index]));

    // final pageRouteBuilder = PageRouteBuilder(
    //   pageBuilder: (context, animation, secondaryAnimation) =>
    //       route.buildPage(context),
    //   transitionsBuilder: (context, animation, secondaryAnimation, child) =>
    //       route.buildTransitions(
    //     context,
    //     animation,
    //     secondaryAnimation,
    //     child,
    //   ),
    // );
    // ExtendedNavigator.of(_context)!.push(
    //   PageRouteBuilder(
    //     transitionDuration: const Duration(milliseconds: 800),
    //     pageBuilder: (context, animation, secondaryAnimation) =>
    //         TournamentDetailView(
    //       tournament: _tournamentList[index],
    //     ),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(
    //         opacity: animation.drive(
    //           Tween(begin: 0.0, end: 1.0).chain(
    //             CurveTween(curve: Curves.easeInOut),
    //           ),
    //         ),
    //         child: child,
    //       );
    //     },
    //   ),
    // );
  }

  void updateTop(double value) {
    _top = value;
    // notifyListeners();
  }

  Future<void> refreshTournaments() {
    return Future.delayed(const Duration(seconds: 2));
  }
}
