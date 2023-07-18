import 'dart:convert';
import 'package:esports_battlefield_arena/app/app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:esports_battlefield_arena/services/payment/stripe.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentService extends Payment {
  @override
  Future<Map<String, dynamic>> createPaymentIntent(
      {required String email, required String amount}) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'email': email,
        'amount': amount,
      };

      //Make post request to our cloud function
      var response = await http.post(
        Uri.parse(
            'https://us-central1-esports-battlefield-arena.cloudfunctions.net/stripePaymentIntentRequest'),
        body: body,
      );

      if (response.statusCode != 200) {
        throw Failure('Failed create payment intent',
            message: response.body.toString(),
            location: 'StripePaymentService.createPaymentIntent');
      }
      return json.decode(response.body);
    } catch (err) {
      throw Failure('Failed create payment intent',
          message: err.toString(),
          location: 'StripePaymentService.createPaymentIntent');
    }
  }

  @override
  Future<void> initPaymentSheet(Map<String, dynamic> paymentIntent) async {
    try {
      //STEP 1: Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent['clientSecret'],
              customerId: paymentIntent['customer'],
              customerEphemeralKeySecret: paymentIntent['ephemeralKey'],
              style: ThemeMode.light,
              merchantDisplayName: 'Esports Battlefield Arena'));
    } catch (err) {
      throw Failure('Failed to init payment sheet',
          message: err.toString(),
          location: 'StripePaymentService.initPaymentSheet');
    }
  }

  @override
  Future<bool> displayPaymentSheet() async {
    try {
      bool paymentSucess = false;
      await Stripe.instance.presentPaymentSheet().then((value) {
        //Need to double check back whether this is working or not
        paymentSucess = true;
      });
      return paymentSucess;
    } on StripeException catch (error) {
      if (error.error.code.toString() == 'FailureCode.Canceled') {
        //don't throw error instead
        return false;
      }
      throw Failure(error.error.code.toString(),
          message: error.error.message.toString(),
          location: 'StripePaymentService.displayPaymentSheet');
    } catch (e) {
      throw Failure('Failed to display payment sheet',
          message: e.toString(),
          location: 'StripePaymentService.displayPaymentSheet');
    }
  }

  @override
  Future<Map<String, dynamic>> cancelPayment(String id) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'paymentIntentId': id,
      };

      //Make post request to our cloud function
      var response = await http.post(
        Uri.parse(
            'https://us-central1-esports-battlefield-arena.cloudfunctions.net/cancelPaymentIntent'),
        body: body,
      );

      if (response.statusCode != 200) {
        throw Failure('Failed to cancel payment intent on the server',
            message: response.body.toString(),
            location: 'StripePaymentService.createPaymentIntent');
      }
      return json.decode(response.body);
    } on Failure {
      rethrow;
    } catch (err) {
      throw Failure('Something wrong when cancelling the payment intent',
          message: err.toString(),
          location: 'StripePaymentService.createPaymentIntent');
    }
  }

  @override
  Future<void> clearAllPaymentSheet() {
    return Stripe.instance.resetPaymentSheetCustomer();
  }
}
