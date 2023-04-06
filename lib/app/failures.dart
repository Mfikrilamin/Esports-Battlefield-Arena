// Change the class name, since Error is already used in Flutter
class Failure {
  final String code;
  final String? message;
  final String? location; // e.g. the class and method where the error occured

  const Failure(this.code, {this.message = '', this.location = ''});

  @override
  String toString() => 'Code: $code\n\nMessage: $message\n\n';

  static const cannotRead = Failure('cannot_read',
      message: 'Cannot read data from the server',
      location: 'firestore_service.dart');

  static const notFound = Failure('not-found',
      message: 'The requested document was not found',
      location: 'firestore_service.dart');
  static const invalidField = Failure('invalid-field',
      message: 'The field is invalid', location: 'firestore_service.dart');
}

Failure firestoreError(String errorCode) {
  Failure error = const Failure('error',
      message:
          'There is an error occurred that is not related to the firestore',
      location: 'firestore_service.dart');
  switch (errorCode) {
    case 'cancelled':
      // Handle cancellation error
      error = const Failure('cancelled',
          message: 'The operation was cancelled',
          location: 'firestore_service.dart');
      break;
    case 'unknown':
      // Handle unknown error
      error = const Failure('unknown',
          message: 'Unknown error or an error from a different error domain.',
          location: 'firestore_service.dart');
      break;
    case 'permission-denied':
      // Handle permission denied error
      error = const Failure('permission-denied',
          message:
              'The caller does not have permission to execute the specified operation',
          location: 'firestore_service.dart');
      break;
    case 'not-found':
      // Handle document not found error
      error = const Failure('not-found',
          message: 'The requested document was not found',
          location: 'firestore_service.dart');
      break;
    case 'already-exists':
      // Handle document already exists error
      error = const Failure('already-exists',
          message: 'The document that is attempted to create already exists',
          location: 'firestore_service.dart');
      break;
    case 'deadline-exceeded':
      // Handle deadline exceed error
      error = const Failure('deadline-exceeded',
          message: 'Deadline expired before operation could complete.',
          location: 'firestore_service.dart');
      break;
    case 'resource-exhausted':
      // Handle document not found error
      error = const Failure('resource-exhausted',
          message:
              'Some resource has been exhausted, perhaps a per-user quota, Deadline expired before operation could complete.',
          location: 'firestore_service.dart');
      break;
    case 'failed-precondition':
      // Handle precondition failed error
      error = const Failure('failed-precondition',
          message:
              'Operation was rejected because the system is not in a state required for the operation\'s execution.',
          location: 'firestore_service.dart');
      break;
    case 'aborted':
      // Handle aborted error
      error = const Failure('aborted',
          message:
              'The operation was aborted, typically due to a concurrency issue like transaction aborts, etc.',
          location: 'firestore_service.dart');
      break;
    case 'out-of-range':
      // Handle out of range error
      error = const Failure('out-of-range',
          message: 'Operation was attempted past the valid range.',
          location: 'firestore_service.dart');
      break;
    case 'unimplemented':
      // Handle unimplemented error
      error = const Failure('unimplemented',
          message: 'Operation is not implemented or not supported/enabled.',
          location: 'firestore_service.dart');
      break;
    case 'internal':
      // Handle internal error
      error = const Failure('internal',
          message:
              'Internal errors. Means some invariants expected by underlying System has been broken.',
          location: 'firestore_service.dart');
      break;
    case 'unavailable':
      // Handle unavailable error
      error = const Failure('unavailable',
          message: 'The service is currently unavailable.',
          location: 'firestore_service.dart');
      break;
    case 'data-loss':
      // Handle data loss error
      error = const Failure('data-loss',
          message: 'Unrecoverable data loss or corruption.',
          location: 'firestore_service.dart');
      break;
    case 'unauthenticated':
      // Handle unauthenticated error
      error = const Failure('unauthenticated',
          message:
              'The request does not have valid authentication credentials for the operation.',
          location: 'firestore_service.dart');
      break;
    default:
      // Handle any other FirebaseException error
      break;
  }
  return error;
}

Failure fireauthError(String errorCode) {
  Failure errorMsg;
  switch (errorCode) {
    case 'invalid-email':
      errorMsg = const Failure('invalid-email',
          message:
              'Email is not properly formated, please insert an email with correct format',
          location: 'fireAuth_service.dart');
      break;
    case 'user-not-found':
      errorMsg = const Failure('user-not-found',
          message: 'There is no user exist for the email provided',
          location: 'fireAuth_service.dart');
      break;
    case 'wrong-password':
      errorMsg = const Failure('wrong-password',
          message: 'The password is not correct',
          location: 'fireAuth_service.dart');
      break;
    case 'user-disabled':
      errorMsg = const Failure('user-disabled',
          message: 'The user account has been disabled by an administrator',
          location: 'fireAuth_service.dart');
      break;
    case 'too-many-requests':
      errorMsg = const Failure('too-many-requests',
          message: 'Too many requests have been made. Please try again later',
          location: 'fireAuth_service.dart');
      break;
    case 'operation-not-allowed':
      errorMsg = const Failure('operation-not-allowed',
          message: 'The email/password accounts are not enabled',
          location: 'fireAuth_service.dart');
      break;
    case 'email-already-in-use':
      errorMsg = const Failure('email-already-in-use',
          message: 'The email is already in use by another account',
          location: 'fireAuth_service.dart');
      break;
    case 'weak-password':
      errorMsg = const Failure('weak-password',
          message: 'The password is not strong enough',
          location: 'fireAuth_service.dart');
      break;
    case 'requires-recent-login':
      errorMsg = const Failure('requires-recent-login',
          message:
              'The user has been deleted or modify recently. Please reauthenticate',
          location: 'fireAuth_service.dart');
      break;
    case 'invalid-credential':
      errorMsg = const Failure('invalid-credential',
          message:
              'the provider\'s credential is not valid. This can happen if it has already expired when calling link, or if it used invalid token(s)',
          location: 'fireAuth_service.dart');
      break;
    case 'user-mismatch':
      errorMsg = const Failure('user-mismatch',
          message:
              'the credential given does not correspond to the current user.',
          location: 'fireAuth_service.dart');
      break;
    default:
      errorMsg = const Failure('error',
          message:
              'There is an error occurred that is not related to the fireauth',
          location: 'fireAuth_service.dart');
      break;
  }
  throw errorMsg;
}
