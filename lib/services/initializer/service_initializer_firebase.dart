import 'package:esports_battlefield_arena/services/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'service_initializer.dart';

class ServiceInitializerImpl extends ServiceInitializer {
  @override
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //Load our .env file that contains our Stripe Secret key
    await dotenv.load(fileName: "assets/.env");
    Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
    await Stripe.instance.applySettings();
  }
}
