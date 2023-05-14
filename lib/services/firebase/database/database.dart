import 'package:esports_battlefield_arena/services/firebase/firestore_config.dart';
import 'package:map_mvvm/service_stream.dart';

abstract class Database with ServiceStream {
  //This is the interface for the firestore service
  //All method declaration for the firestore service is declared here and implemented in the firestore_service.dart
  Future<String?> add(
      Map<String, dynamic> data, FirestoreCollections collection);
  Future<void> update(String documentId, Map<String, dynamic> data,
      FirestoreCollections collection);
  Future<void> delete(String documentId, FirestoreCollections collection);
  Future<Map<String, dynamic>> get(
      String documentId, FirestoreCollections collection);
  Future<Map<String, dynamic>?> getByQuery(
      List<String> field, List<String> value, FirestoreCollections collection);
  Future<List> getAll(FirestoreCollections collection);
  Future<List<Map<String, dynamic>>> getAllByQuery(
      List<String> field, List<String> value, FirestoreCollections collection);
  Future<List<Map<String, dynamic>>> getAllByQueryList(
      String field, String value, FirestoreCollections collection);
  Stream<Map<String, dynamic>> streamByQuery(
      List<String> field, List<String> value, FirestoreCollections collection);
}
