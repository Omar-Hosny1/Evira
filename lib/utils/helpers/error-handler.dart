import 'package:firebase_auth/firebase_auth.dart';

Future<void> errorHandler({required Function tryLogic}) async {
  try {
    await tryLogic();
  } on FirebaseAuthException catch (e) {
    print('******************** Firebase Error Message ********************');
    print(e.code);
    print(e.message);
    var errMsg = 'Something Went Wrong';
    switch (e.code) {
      case 'email-already-exists':
        errMsg = 'The Email already exists...';
        break;
      case 'email-already-in-use':
        errMsg = 'The Email already exists...';
        break;
      case 'weak-password':
        errMsg = 'The password provided is too weak...';
        break;
      case 'invalid-credential':
        errMsg = 'Invalid password try Again...';
        break;
      case 'too-many-requests':
        errMsg = 'Too many requests try Again Later...';
        break;
      case 'invalid-email':
        errMsg = 'Try another Well-Formatted Email...';
        break;
      default:
        errMsg = 'Something Went Wrong';
    }
    throw Exception(errMsg);
  } on FirebaseException catch (e) {
    print('******************** Firebase Error Message ********************');
    print(e.message);
    throw Exception(e.message);
  } catch (e) {
    throw Exception(e.toString());
  }
}
