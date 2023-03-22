import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:map_mvvm/service_stream.dart';

abstract class Firestore with ServiceStream {
  //This is the interface for the firestore service
  //All method declaration for the firestore service is declared here and implemented in the firestore_service.dart
  add(Map<String, dynamic> data, FirestoreCollections collection);
  update(String documentId, Map<String, dynamic> data, FirestoreCollections collection);
  delete(String documentId, FirestoreCollections collection);
  Future get(String documentId, FirestoreCollections collection);
  Future<List> getAll(FirestoreCollections collection);
}
