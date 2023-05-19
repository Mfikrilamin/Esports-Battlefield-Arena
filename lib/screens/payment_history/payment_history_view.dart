import 'dart:developer';
import 'dart:ffi';

import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/models/invoice.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/screens/payment_history/payment_history_viewmodel.dart';
import 'package:esports_battlefield_arena/services/payment/stripe_service.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_button.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/shared/ui_helper.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

@RoutePage()
class PaymentHistoryView extends StatelessWidget {
  const PaymentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    print("PaymentHistoryView page is being built");
    return ViewModelBuilder<PaymentHistoryViewModel>.reactive(
      viewModelBuilder: () => PaymentHistoryViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: kcPrimaryColor,
          title: BoxText.appBar('BILLS', color: kcDarkTextColor),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: LiquidPullToRefresh(
          onRefresh: model.refreshInvoiceList,
          // showChildOpacityTransition: false,
          color: kcPrimaryColor,
          animSpeedFactor: 2,
          backgroundColor: kcPrimaryLightColor,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: const BillNavigationButton(),
              ),
              const Divider(
                color: kcVeryLightGreyColor,
                thickness: 1,
                height: 0,
              ),
              model.invoiceList.isNotEmpty
                  ? const Expanded(
                      child: InvoiceCard(),
                    )
                  : const Center(
                      child: BoxText.headingThree('No receipt available'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class BillNavigationButton extends StackedHookView<PaymentHistoryViewModel> {
  const BillNavigationButton({Key? key}) : super(key: key, reactive: true);
  @override
  Widget builder(BuildContext context, PaymentHistoryViewModel model) {
    log('BillNavigationButton is being built', name: 'BillNavigationButton');
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          children:
              // [
              model.OPTIONS
                  .map(
                    (label) => ChoiceChip(
                      label: Text(label),
                      selected: model.selectedLabel == label,
                      selectedColor: kcPrimaryColor,
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(
                        color: kcVeryLightGreyColor,
                        width: 1,
                      ),
                      labelStyle: model.selectedLabel == label
                          ? const TextStyle(
                              color: kcDarkTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            )
                          : const TextStyle(
                              color: kcDarkGreyColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                      onSelected: (value) {
                        // print(value);
                        // if (label == OPTIONS[0]) {
                        //   model.onButtonUpcomingTap();
                        // } else {
                        //   model.onButtonAllTap();
                        // }
                        model.onChoiceChipTap(label);
                      },
                    ),
                  )
                  .toList(),
        )
      ],
    );
  }
}

class InvoiceCard extends StackedHookView<PaymentHistoryViewModel> {
  const InvoiceCard({super.key});

  @override
  Widget builder(BuildContext context, PaymentHistoryViewModel model) {
    return ListView.separated(
      itemCount: model.invoiceList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        log('Building Invoice Card ${index + 1}', name: 'InvoiceCard');
        return GestureDetector(
          onTap: () {
            model.makeUnresolvePayment(model.invoiceList[index], context);
          },
          child: Container(
            // height: isExpanded ? _ACTIVEHEIGHT : _INACTIVEHEIGHT,
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2.0,
            ),
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoxText.subheading(model.getTournamentName(
                          model.invoiceList[index].tournamentId)),
                      BoxText.body(
                          'Paid by : ${model.getPaidBy(model.invoiceList[index].invoiceId).isEmpty ? 'Not paid yet' : model.getPaidBy(model.invoiceList[index].invoiceId)}'),
                      BoxText.body(model.invoiceList[index].date.isEmpty
                          ? 'No date'
                          : model.invoiceList[index].date),
                      UIHelper.verticalSpaceSmall(),
                      BoxText.caption(
                          'Invoice Id: ${model.invoiceList[index].invoiceId}'),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: model.invoiceList[index].isPaid
                            ? kcPrimaryColor
                            : kcTertiaryColor,
                      ),
                      child: Center(
                        child: BoxText.caption(
                          model.invoiceList[index].isPaid ? 'Paid' : 'Unpaid',
                        ),
                      ),
                    ),
                    BoxText.headingFive(
                        'RM ${model.invoiceList[index].amount}'),
                  ],
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        // <-- SEE HERE
        return const Divider(
          // thickness: 1,
          height: 1,
          color: kcLightGreyColor,
        );
      },
    );
  }
}
