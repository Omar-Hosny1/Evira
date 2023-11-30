import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import '../models/user.dart' as U;
import 'package:firebase_storage/firebase_storage.dart';

class AuthDS {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final firebaseStorage = FirebaseStorage.instance;

  Future<UserCredential> _signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _authInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  }

  Future<String> _uploadFile(File photo) async {
    try {
      final fileName = basename(photo.path);
      final destination = 'usersPictures/$fileName';

      final ref = firebaseStorage.ref(destination);
      final task = await ref.putFile(photo);
      return await task.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(U.User user) async {
    final userData = user.getUserData();
    try {
      final credentials = await _signUpWithEmailAndPassword(
        userData[U.UserDataEnum.email],
        userData[U.UserDataEnum.password],
      );
      final fileUrl = await _uploadFile(userData[U.UserDataEnum.image]);

      print('*************** fileUrl ***************');
      print(fileUrl);
    } on FirebaseAuthException catch (e) {
      var errMsg = 'Something Went Wrong';
      if (e.code == 'weak-password') {
        errMsg = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errMsg = 'The account already exists for that email.';
      }
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  void listenToUserStates(void Function(User?)? onData) =>
      _authInstance.authStateChanges().listen(onData);

  signOut() async {
    await _authInstance.signOut();
  }
}
