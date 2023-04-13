import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/components/widgets/bottom_nagivation_bar.dart';
import 'package:esports_battlefield_arena/screens/Example/example.dart';
import 'package:esports_battlefield_arena/screens/home/home_viewmodel.dart';
import 'package:esports_battlefield_arena/screens/payment_history/payment_history_view.dart';
import 'package:esports_battlefield_arena/screens/player_home/player_home_view.dart';
import 'package:esports_battlefield_arena/screens/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

@RoutePage()
class HomeView extends StatelessWidget {
  // static Route route() => MaterialPageRoute(builder: (_) => const HomeView());
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => Scaffold(
        // appBar: ,
        body: buildBodyWidget(model.selectedIndex),
        bottomNavigationBar: const CustomBottomNavigationBar(),
      ),
    );
  }
}

Widget buildBodyWidget(int index) {
  switch (index) {
    case 0:
      return const PlayerHomeView();
    case 1:
      return const ExampleView();
    case 2:
      return const PaymentHistoryView();
    default:
      return const ProfileView();
  }
}

// class PlayerHomeView extends StatelessWidget {
//   PlayerHomeView({Key? key}) : super(key: key);

//   double top = 0.00;

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       slivers: [
//         SliverAppBar(
//           pinned: true,
//           backgroundColor: kcPrimaryColor,
//           expandedHeight: 200,
//           flexibleSpace: LayoutBuilder(
//               builder: (BuildContext context, BoxConstraints constraints) {
//             top = constraints.biggest.height;
//             return FlexibleSpaceBar(
//               title: AnimatedOpacity(
//                 duration: const Duration(milliseconds: 300),
//                 opacity: 1.0,
//                 child:
//                     (top == MediaQuery.of(context).padding.top + kToolbarHeight)
//                         ? BoxText.appBar('ARENA', color: kcDarkTextColor)
//                         : BoxText.appBar('ARENA', color: kcPrimaryLightColor),
//               ),
//               centerTitle: true,
//               background: const Image(
//                 image: AssetImage('assets/images/home.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             );
//           }),
//         ),
//         SliverList(
//           delegate: SliverChildBuilderDelegate((context, index) {
//             return ListTile(
//               title: BoxText.body('Item ${index + 1}'),
//             );
//           }),
//         ),
//       ],
//     );
//   }
// }
