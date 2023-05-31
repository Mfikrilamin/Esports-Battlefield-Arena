import 'package:auto_route/auto_route.dart';
import 'package:direct_select/direct_select.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/screens/create_tournament/create_tournament_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_button.dart';
import 'package:esports_battlefield_arena/shared/box_input_field.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/shared/ui_helper.dart';
import 'package:esports_battlefield_arena/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

@RoutePage()
class CreateTournamentView extends StatelessWidget {
  const CreateTournamentView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateTournamentViewModel>.reactive(
      viewModelBuilder: () => CreateTournamentViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kcPrimaryColor,
          title: BoxText.appBar('ARENA', color: kcDarkTextColor),
          centerTitle: true,
          leading: IconButton(
            color: kcDarkTextColor,
            onPressed: () {
              model.navigateToPreviousPage();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: BoxText.headingThree(
                  model.editFlag ? 'Edit Tournament' : 'Create Tournament'),
            ),
            const TournamentTitleInputField(),
            UIHelper.verticalSpaceSmall(),
            const TournamentDescriptionInputField(),
            UIHelper.verticalSpaceSmall(),
            const DoubleInputField(true, 'Prize pool', '900.00'),
            UIHelper.verticalSpaceSmall(),
            const DoubleInputField(
              false,
              'Entry Fee',
              '5.00',
            ),
            UIHelper.verticalSpaceSmall(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                DateInputField(
                  'Start Date',
                  'Pick Date',
                  isStartDate: true,
                ),
                DateInputField(
                  'End Date',
                  'Pick Date',
                  isStartDate: false,
                ),
              ],
            ),
            UIHelper.verticalSpaceSmall(),
            const GameInputField(),
            UIHelper.verticalSpaceSmall(),
            const ParticipationTypeInputField(),
            UIHelper.verticalSpaceSmall(),
            const GamePerMatchInputField(),
            UIHelper.verticalSpaceSmall(),
            Row(
              children: const [
                DigitInputField('Max Participants', '15', true),
                DigitInputField('Member per team', '5', false),
              ],
            ),
            UIHelper.verticalSpaceSmall(),
            const RuleListInputField(),
            UIHelper.verticalSpaceMediumLarge(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
              child: BoxButton(
                title:
                    model.editFlag ? 'Update Tournament' : 'Create Tournament',
                onTap: () {
                  model.processTournamentData(context);
                },
                busy: model.isBusy,
              ),
            ),
            UIHelper.verticalSpaceMedium(),
          ],
        ),
      ),
    );
  }
}

class TournamentTitleInputField
    extends StackedHookView<CreateTournamentViewModel> {
  const TournamentTitleInputField({Key? key}) : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, CreateTournamentViewModel model) {
    var controller = useTextEditingController(text: model.title);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxText.body('Tournament Title'),
          UIHelper.verticalSpaceSmall(),
          BoxInputField(
            readOnly: false,
            controller: controller,
            placeholder: 'Enter title',
            onChanged: model.updateTournamentTitle,
          ),
        ],
      ),
    );
  }
}

class TournamentDescriptionInputField
    extends StackedHookView<CreateTournamentViewModel> {
  const TournamentDescriptionInputField({Key? key})
      : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, CreateTournamentViewModel model) {
    var controller = useTextEditingController(text: model.description);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxText.body('Description'),
          UIHelper.verticalSpaceSmall(),
          BoxInputField(
            readOnly: false,
            controller: controller,
            placeholder: 'Enter description',
            onChanged: model.updateTournamentDescription,
          ),
        ],
      ),
    );
  }
}

class DoubleInputField extends StackedHookView<CreateTournamentViewModel> {
  final bool isPrizePool;
  final String title;
  final String placeholder;
  const DoubleInputField(this.isPrizePool, this.title, this.placeholder,
      {Key? key})
      : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, CreateTournamentViewModel model) {
    var controller = useTextEditingController(
        text: isPrizePool
            ? model.prizePool.toString()
            : model.entryFee.toString());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxText.body(title),
          UIHelper.verticalSpaceSmall(),
          BoxInputField(
            readOnly: false,
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
            ],
            placeholder: placeholder,
            onChanged: (input) {
              if (input == '') {
                input = '0.00';
              }
              if (isPrizePool) {
                model.updateTournamentPrizePool(input);
              } else {
                model.updateTournamentFee(input);
              }
            },
          ),
        ],
      ),
    );
  }
}

class DateInputField extends StackedHookView<CreateTournamentViewModel> {
  final String title;
  final String placeholder;
  final bool isStartDate;
  const DateInputField(this.title, this.placeholder,
      {Key? key, this.isStartDate = false})
      : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, CreateTournamentViewModel model) {
    var controller = useTextEditingController(
        text: isStartDate
            ? model.startDate == null
                ? placeholder
                : DateHelper.formatDate(model.startDate!)
            : model.endDate == null
                ? placeholder
                : DateHelper.formatDate(model.endDate!));
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoxText.body(title),
            UIHelper.verticalSpaceSmall(),
            BoxInputField(
              readOnly: true,
              controller: controller,
              leading: const Icon(Icons.calendar_month_outlined),
              placeholder: placeholder,
              onTap: () async {
                if (!isStartDate) {
                  if (model.startDate == null) {
                    //show dialog error
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                                Text("Please select start date"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                    return;
                  }
                }
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: isStartDate
                      ? model.startDate == null
                          ? DateTime.now()
                          : model.startDate!
                      : model.endDate == null
                          ? model.startDate!
                          : model.endDate!,
                  firstDate: isStartDate ? DateTime.now() : model.startDate!,
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (selectedDate != null) {
                  //format the date
                  String formatDate = DateHelper.formatDate(selectedDate);
                  controller.text = formatDate;
                  //Update viewmodel
                  if (isStartDate) {
                    model.updateStartDate(selectedDate);
                  } else {
                    model.updateEndDate(selectedDate);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GameInputField extends StackedHookView<CreateTournamentViewModel> {
  const GameInputField({Key? key}) : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, CreateTournamentViewModel model) {
    List<Widget> buildGameItem() {
      return model.gameList
          .map((e) => MySelectionItem(
                isForList: true,
                title: e,
              ))
          .toList();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxText.body('Game selection'),
          UIHelper.verticalSpaceSmall(),
          DirectSelect(
            mode: DirectSelectMode.tap,
            itemExtent: 45.0,
            selectedIndex: model.gameSelectedIndex,
            // backgroundColor: Colors.red,
            onSelectedItemChanged: model.updateGameSelectedIndex,
            items: buildGameItem(),
            child: MySelectionItem(
              isForList: false,
              title: model.gameList[model.gameSelectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

class ParticipationTypeInputField
    extends StackedHookView<CreateTournamentViewModel> {
  const ParticipationTypeInputField({Key? key})
      : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, CreateTournamentViewModel model) {
    List<Widget> buildModeItem() {
      return model.participationTypeList
          .map((e) => MySelectionItem(
                isForList: true,
                title: e,
              ))
          .toList();
    }

    List<Widget> buildModeItem2() {
      // Get the first element of the participationTypeList
      String lastElement = model.participationTypeList.last;

      // Create a list with a single widget containing the first element
      List<Widget> widgetList = [
        MySelectionItem(
          isForList: false,
          title: lastElement,
        ),
      ];

      return widgetList;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxText.body('Mode type'),
          UIHelper.verticalSpaceSmall(),
          DirectSelect(
            mode: DirectSelectMode.tap,
            itemExtent: 45.0,
            selectedIndex:
                model.gameSelectedIndex == 0 ? 1 : model.modeSelectedIndex,
            // backgroundColor: Colors.red,
            onSelectedItemChanged: (value) {
              model.gameSelectedIndex == 0 ? value = 1 : value = value;
              model.updateModeSelectedIndex(value);
            },
            items: model.gameSelectedIndex == 0
                ? buildModeItem2()
                : buildModeItem(),
            child: MySelectionItem(
              isForList: model.gameSelectedIndex == 0 ? true : false,
              title: model.participationTypeList[model.modeSelectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

//You can use any Widget
class MySelectionItem extends StatelessWidget {
  final String title;
  final bool isForList;

  const MySelectionItem({Key? key, required this.title, this.isForList = true})
      : super(key: key);

  Widget _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: isForList
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: _buildItem(context),
            )
          : Card(
              // margin: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: kcLightGreyColor),
                      borderRadius: BorderRadius.circular(8.0),
                      color: kcVeryLightGreyColor,
                    ),
                    child: _buildItem(context),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.unfold_more),
                  )
                ],
              ),
            ),
    );
  }
}

class GamePerMatchInputField
    extends StackedHookView<CreateTournamentViewModel> {
  const GamePerMatchInputField({Key? key}) : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, CreateTournamentViewModel model) {
    var controller =
        useTextEditingController(text: model.gamePerMatch.toString());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxText.body('Game per match'),
          UIHelper.verticalSpaceSmall(),
          BoxInputField(
            readOnly: false,
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            placeholder: '3',
            onChanged: (digit) {
              if (digit == '') {
                digit = '0';
              }
              model.updateGamePerMatch(digit);
            },
          ),
        ],
      ),
    );
  }
}

class DigitInputField extends StackedHookView<CreateTournamentViewModel> {
  final String title;
  final String placeholder;
  final bool isMaxParticipantField;
  const DigitInputField(
      this.title, this.placeholder, this.isMaxParticipantField,
      {Key? key})
      : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, CreateTournamentViewModel model) {
    var controller = useTextEditingController(
        text: isMaxParticipantField
            ? model.maxParticipant.toString()
            : model.memberPerTeam.toString());
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoxText.body(title),
            UIHelper.verticalSpaceSmall(),
            BoxInputField(
              readOnly: false,
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              placeholder: placeholder,
              onChanged: (digit) {
                if (digit == '') {
                  digit = '0';
                }
                if (isMaxParticipantField) {
                  model.updateMaxParticipants(digit);
                } else {
                  model.updateMemberPerTeam(digit);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RuleListInputField extends StackedHookView<CreateTournamentViewModel> {
  const RuleListInputField({Key? key}) : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, CreateTournamentViewModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoxText.body('Rules'),
            // UIHelper.verticalSpaceSmall(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: model.ruleList.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == model.ruleList.length) {
                  return Column(
                    children: [
                      UIHelper.verticalSpaceSmall(),
                      BoxButton(
                        leading: const Icon(
                          Icons.add_circle_outline_sharp,
                          color: kcLightGreyColor,
                        ),
                        title: 'Add new rule',
                        height: 38,
                        width: 200,
                        disable: true,
                        // outline: true,
                        onTap: () {
                          model.addNewRule();
                        },
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    UIHelper.verticalSpaceSmall(),
                    RuleInputField(index),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RuleInputField extends StackedHookView<CreateTournamentViewModel> {
  final int index;
  const RuleInputField(
    this.index, {
    super.key,
  });

  @override
  Widget builder(BuildContext context, CreateTournamentViewModel model) {
    var controller = useTextEditingController(text: model.ruleList[index]);
    return BoxInputField(
      readOnly: false,
      controller: controller,
      placeholder: 'Rules number ${index + 1}',
      onChanged: (rule) {
        model.updateTournamentRule(rule, index);
      },
      trailing: const Icon(
        Icons.delete,
        color: kcMediumGreyColor,
      ),
      traillingTapped: () {
        model.removeRule(index);
      },
    );
  }
}
