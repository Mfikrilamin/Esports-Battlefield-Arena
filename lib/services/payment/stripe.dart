import 'package:flutter/material.dart';

abstract class Payment {
  Future<void> initPaymentSheet(Map<String, dynamic> paymentIntent);
  Future<Map<String, dynamic>> createPaymentIntent(
      {required String email, required String amount});
  Future<bool> displayPaymentSheet();
}
