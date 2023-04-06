import 'package:esports_battlefield_arena/screens/player_home/player_home_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PlayerHomeView extends StatelessWidget {
  const PlayerHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PlayerHomeViewModel>.reactive(
      viewModelBuilder: () => PlayerHomeViewModel(),
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: kcPrimaryColor,
              expandedHeight: 200,
              flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                model.updateTop(constraints.biggest.height);
                return FlexibleSpaceBar(
                  title: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: 1.0,
                    child: (model.top ==
                            MediaQuery.of(context).padding.top + kToolbarHeight)
                        ? BoxText.appBar('ARENA', color: kcDarkTextColor)
                        : BoxText.appBar('ARENA', color: kcPrimaryLightColor),
                  ),
                  centerTitle: true,
                  background: const Image(
                    image: AssetImage('assets/images/home.jpg'),
                    fit: BoxFit.cover,
                  ),
                );
              }),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return ListTile(
                  title: BoxText.body('Item ${index + 1}'),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
