import 'package:map_mvvm/service_stream.dart';

abstract class Auth with ServiceStream {
  //This is the interface for the firestore service
  //All method declaration for the firestore service is declared here and implemented in the firestore_service.dart
  Future<String?> signIn(String email, String password);
  signOut(String email, String password);
  resetPassword(String email);
  Future<String?> createAccount(String email, String password);
  bool isUserSignOn();
  deleteUserAuth();
  reAuthenticate(String email, String password);
  String? currentUser();
  String? getCurrentUserEmail();
}
