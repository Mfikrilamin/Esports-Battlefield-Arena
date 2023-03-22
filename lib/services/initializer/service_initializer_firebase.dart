import 'package:esports_battlefield_arena/services/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'service_initializer.dart';

class ServiceInitializerFirebase extends ServiceInitializer {
  @override
  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}
