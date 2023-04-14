import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:esports_battlefield_arena/services/payment/stripe.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentService extends StripePayment {
  @override
  Future<void> makePayment(Map<String, dynamic>? paymentIntent) async {
    try {
      //STEP 1: Create Payment Intent
      paymentIntent = await createPaymentIntent('100', 'USD');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(paymentIntent);
    } catch (err) {
      throw Exception(err);
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  displayPaymentSheet(Map<String, dynamic>? paymentIntent) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        print('Payment Successfull');
        // showDialog(
        //     context: context,
        //     builder: (_) => AlertDialog(
        //           content: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Row(
        //                 children: const [
        //                   Icon(
        //                     Icons.check_circle,
        //                     color: Colors.green,
        //                   ),
        //                   Text("Payment Successfull"),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      // showDialog(
      //     context: context,
      //     builder: (_) => const AlertDialog(
      //           content: Text("Cancelled "),
      //         ));
    } catch (e) {
      print('$e');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}
