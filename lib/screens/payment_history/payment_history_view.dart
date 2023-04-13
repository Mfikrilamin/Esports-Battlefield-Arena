import 'dart:developer';
import 'dart:ffi';

import 'package:auto_route/auto_route.dart';
import 'package:esports_battlefield_arena/models/invoice.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/screens/payment_history/payment_history_viewmodel.dart';
import 'package:esports_battlefield_arena/shared/app_colors.dart';
import 'package:esports_battlefield_arena/shared/box_button.dart';
import 'package:esports_battlefield_arena/shared/box_text.dart';
import 'package:esports_battlefield_arena/shared/ui_helper.dart';
import 'package:esports_battlefield_arena/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

@RoutePage()
class PaymentHistoryView extends StatelessWidget {
  const PaymentHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    print("PaymentHistoryView page is being built");
    return ViewModelBuilder<PaymentHistoryViewModel>.nonReactive(
      viewModelBuilder: () => PaymentHistoryViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: kcPrimaryColor,
          title: BoxText.appBar('BILLS', color: kcDarkTextColor),
          centerTitle: true,
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
                height: 1,
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
    final double _BUTTONHEIGHT = 35;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: _BUTTONHEIGHT,
          alignment: Alignment.center,
          child: BoxButton(
            title: 'Upcoming',
            outline: true,
            selected: model.isSelectedUpcoming ? true : false,
            onTap: model.onButtonUpcomingTap,
          ),
        ),
        UIHelper.horizontalSpaceSmall(),
        Container(
          width: 50,
          height: _BUTTONHEIGHT,
          alignment: Alignment.center,
          child: BoxButton(
            title: 'All',
            outline: true,
            selected: model.isSelectedUpcoming ? false : true,
            onTap: model.onButtonAllTap,
          ),
        ),
      ],
    );
  }
}

class InvoiceCard extends StackedHookView<PaymentHistoryViewModel> {
  const InvoiceCard({super.key});

  @override
  Widget builder(BuildContext context, PaymentHistoryViewModel model) {
    return ListView.builder(
      itemCount: model.invoiceList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        log('Building Invoice Card ${index + 1}', name: 'InvoiceCard');
        return GestureDetector(
          onTap: () {},
          child: Container(
            // height: isExpanded ? _ACTIVEHEIGHT : _INACTIVEHEIGHT,
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 2.0,
            ),
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(
              border: BorderDirectional(
                bottom: BorderSide(
                  color: kcVeryLightGreyColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BoxText.subheading('Invoice Title'),
                    BoxText.body(model.invoiceList[index].date),
                    BoxText.body(model.invoiceList[index].time),
                    UIHelper.verticalSpaceSmall(),
                    BoxText.caption(
                        'Invoice Id: ${model.invoiceList[index].invoiceId}'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: model.invoiceList[index].paidBy.isNotEmpty &&
                                model.invoiceList[index].paidBy != 'null'
                            ? kcPrimaryColor
                            : kcTertiaryColor,
                      ),
                      child: Center(
                        child: BoxText.caption(
                          model.invoiceList[index].paidBy.isNotEmpty &&
                                  model.invoiceList[index].paidBy != 'null'
                              ? 'Paid'
                              : 'Unpaid',
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
    );
  }
}
