import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

String formatErrorMessage(String errMsg) {
  if (errMsg.startsWith('Exception: ')) {
    return errMsg.substring(11);
  }
  return errMsg;
}

Future<T> errorHandler<T>(
    {required Future<T> Function() tryLogic, int? secondsToCancel}) async {
  try {
    secondsToCancel ??= 10;
    return await tryLogic().timeout(Duration(seconds: secondsToCancel),
        onTimeout: () {
      throw FirebaseException(
        plugin: 'network-request-failed',
        message: 'network-request-failed',
      );
    });
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
        errMsg = 'Invalid Email or Password try Again Later...';
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
    if (e.message == 'network-request-failed') {
      throw Exception('Check Your Network And Try Aganin Later...');
    }
    throw Exception(e.message);
  } on SocketException {
    throw Exception('No Internet Connection');
  } catch (e) {
    print(e.runtimeType);
    print('...................... e.runtimeType');
    rethrow;
  }
}
