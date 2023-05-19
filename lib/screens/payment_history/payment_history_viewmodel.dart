import 'package:esports_battlefield_arena/app/failures.dart';
import 'package:esports_battlefield_arena/app/router.dart';
import 'package:esports_battlefield_arena/app/router.gr.dart';
import 'package:esports_battlefield_arena/app/service_locator.dart';
import 'package:esports_battlefield_arena/models/invoice.dart';
import 'package:esports_battlefield_arena/models/player.dart';
import 'package:esports_battlefield_arena/models/team.dart';
import 'package:esports_battlefield_arena/models/tournament.dart';
import 'package:esports_battlefield_arena/models/tournament_participant.dart';
import 'package:esports_battlefield_arena/models/user.dart';
import 'package:esports_battlefield_arena/services/firebase/authentication/auth.dart';
import 'package:esports_battlefield_arena/services/firebase/database/database.dart';
import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:esports_battlefield_arena/services/log/log_services.dart';
import 'package:esports_battlefield_arena/services/payment/stripe.dart';
import 'package:esports_battlefield_arena/services/payment/stripe_service.dart';
import 'package:esports_battlefield_arena/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PaymentHistoryViewModel extends FutureViewModel<void> {
  final AppRouter _router = locator<AppRouter>();
  final Payment _stripePaymentService = locator<Payment>();
  final Auth _auth = locator<Auth>();
  final Database _database = locator<Database>();
  final LogService _log = locator<LogService>();

  final List<String> OPTIONS = [
    'Upcoming',
    'All',
  ];

  String _selectedLabel = 'Upcoming';
  List<Invoice> _unpaidInvoiceList = [];
  List<Invoice> _invoiceList = [];
  List<Invoice> _paidInvoiceList = [];
  Map<String, String> _tournamentName = {};
  Map<String, String> _paidName = {};

  String get selectedLabel => _selectedLabel;
  List<Invoice> get invoiceList => _invoiceList;

  Future<void> refreshInvoiceList() async {
    await getInvoiceList();
    notifyListeners();
    return Future.value();
  }

  onChoiceChipTap(String label) {
    _selectedLabel = label;
    if (_selectedLabel == OPTIONS[0]) {
      _selectedLabel = OPTIONS[0];
      _invoiceList = _unpaidInvoiceList;
    } else {
      _selectedLabel = OPTIONS[1];
      _invoiceList = [..._unpaidInvoiceList, ..._paidInvoiceList];
    }
    notifyListeners();
  }

  void makeUnresolvePayment(Invoice invoice, context) async {
    try {
      String? userEmail = _auth.getCurrentUserEmail();
      if (userEmail == null) {
        throw const Failure("No user login",
            message: 'Please login first',
            location: "PaymentHistoryViewModel.makeUnresolvePayment");
      }
      //Even if the user didn't manage to make payment during the registration, the new payment intent will be created
      //Using the information from the invoice
      Map<String, dynamic> paymentIntent =
          await _stripePaymentService.createPaymentIntent(
              email: userEmail, amount: invoice.amount.toString());

      await _stripePaymentService.initPaymentSheet(paymentIntent);

      bool paymentSucess = await _stripePaymentService.displayPaymentSheet();
      //update invoice status
      Invoice newInvoice = Invoice(
          tournamentId: invoice.tournamentId,
          invoiceId: invoice.invoiceId,
          amount: invoice.amount,
          paymentReferenceId: paymentIntent['paymentIntentId'],
          paidBy: paymentSucess ? _auth.currentUser()! : '',
          belongsTo: invoice.belongsTo,
          paidCompleted: paymentSucess,
          date: paymentSucess ? DateHelper.formatDate(DateTime.now()) : '',
          time: paymentSucess ? DateHelper.formatTime(DateTime.now()) : '');

      if (paymentSucess) {
        //update invoice status
        await _database.update(invoice.invoiceId, newInvoice.toJson(),
            FirestoreCollections.invoice);
        // update tournament participant hasPay to true
        await _database.update(invoice.belongsTo, {'hasPay': paymentSucess},
            FirestoreCollections.tournamentParticipant);
        //update tournament current participantList
        Tournament tournament = Tournament.fromJson(await _database.get(
            invoice.tournamentId, FirestoreCollections.tournament));
        tournament.currentParticipant.add(invoice.belongsTo);
        await _database.update(tournament.tournamentId, tournament.toJson(),
            FirestoreCollections.tournament);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    Text("Payment Successfull"),
                  ],
                ),
              ],
            ),
          ),
        );
        await refreshInvoiceList();
      } else {
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
                    Text("Payment Failed"),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    } on Failure catch (e) {
      _log.debug(e.toString());
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text(e.message!),
        ),
      );
    } catch (e) {
      _log.debug(e.toString());
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Error occured"),
        ),
      );
    }
  }

  Future<void> getInvoiceList() async {
    try {
      List<dynamic> dataInvoices = [];

      List<Map<String, dynamic>> participantMemberList =
          await _database.getAllByQueryList('memberList', _auth.currentUser()!,
              FirestoreCollections.tournamentParticipant);

      for (int i = 0; i < participantMemberList.length; i++) {
        Map<String, dynamic>? dataInvoice = await _database.getByQuery(
            ['belongsTo'],
            [participantMemberList[i]['participantId']],
            FirestoreCollections.invoice);
        dataInvoices.add(dataInvoice);
      }

      // // Search for all invoice that is paid user - START
      // List<Map<String, dynamic>> userParticipantsData = await _database
      //     .getAllByQuery(['participatedBy'], [_auth.currentUser()!],
      //         FirestoreCollections.tournamentParticipant);

      // for (int i = 0; i < userParticipantsData.length; i++) {
      //   Map<String, dynamic>? dataInvoice = await _database.getByQuery(
      //       ['paidBy'],
      //       [userParticipantsData[i]['participantId']],
      //       FirestoreCollections.invoice);
      //   dataInvoices.add(dataInvoice);
      // }
      // // Search for all invoice that is paid user - END

      // // Search for all invoice that is paid by the team that the user joined - START
      // List<Map<String, dynamic>> teamDataJoinedByUser =
      //     await _database.getAllByQueryList(
      //         'memberList', _auth.currentUser()!, FirestoreCollections.team);

      // for (int i = 0; i < teamDataJoinedByUser.length; i++) {
      //   Map<String, dynamic>? dataInvoicesTeam = await _database.getByQuery(
      //       ['paidBy'],
      //       [teamDataJoinedByUser[i]['teamId']],
      //       FirestoreCollections.invoice);
      //   dataInvoices.add(dataInvoicesTeam);
      // }
      // // Search for all invoice that is paid by the team that the user joined - END

      _log.info('Invoice List: $dataInvoices');
      _log.debug('list length: ${dataInvoices.length}');
      _log.debug('first invoice ${dataInvoices[0]}');

      // dataInvoices.map((invoice) => Invoice.fromJson(invoice)).toList();
      List<Invoice> tempPaidInvoiceList = [];
      List<Invoice> tempUnpaidInvoiceList = [];
      for (int i = 0; i < dataInvoices.length; i++) {
        Invoice newInvoice = Invoice.fromJson(dataInvoices[i]);
        Tournament tournament = Tournament.fromJson(await _database.get(
            newInvoice.tournamentId, FirestoreCollections.tournament));
        _tournamentName.putIfAbsent(
            tournament.tournamentId, () => tournament.title);
        if (newInvoice.paidBy.isNotEmpty) {
          Player player = Player.fromJson(await _database.get(
              newInvoice.paidBy, FirestoreCollections.player));
          _paidName.putIfAbsent(newInvoice.invoiceId,
              () => '${player.firstName} ${player.lastName}');
        } else {
          _paidName.putIfAbsent(newInvoice.invoiceId, () => '');
        }
        _log.debug('Invoice: ${newInvoice.toJson()}');
        if (newInvoice.isPaid == false) {
          tempUnpaidInvoiceList.add(newInvoice);
          // _invoiceList.add(newInvoice);
          // _tempInvoiceList.add(newInvoice);
        } else {
          tempPaidInvoiceList.add(newInvoice);
        }
        _unpaidInvoiceList = tempUnpaidInvoiceList;
        _invoiceList = tempUnpaidInvoiceList;
        _paidInvoiceList = tempPaidInvoiceList;
        if (_selectedLabel == OPTIONS[0]) {
          _invoiceList = _unpaidInvoiceList;
        } else {
          _invoiceList = [..._unpaidInvoiceList, ..._paidInvoiceList];
        }
      }
      _log.info('Invoice List: ${_invoiceList.toString()}');
      _log.info('Paid Invoice List: ${_paidInvoiceList.toString()}');
    } on Failure catch (e) {
      _log.debug(e.toString());
    } on ArgumentError catch (e) {
      _log.debug(e.toString());
    } catch (e) {
      _log.debug(e.toString());
    }
  }

  String getTournamentName(String tournamentId) {
    return _tournamentName[tournamentId]!;
  }

  String getPaidBy(String invoiceId) {
    return _paidName[invoiceId]!;
  }

  @override
  Future<void> futureToRun() => getInvoiceList();
}
