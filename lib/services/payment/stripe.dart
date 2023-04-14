abstract class StripePayment {
  Future<void> makePayment(Map<String, dynamic>? paymentIntent);
}
