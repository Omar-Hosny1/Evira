import 'dart:convert';
import 'dart:io';

import 'package:evira/utils/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart' as U;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthDS {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection(Strings.userCollectionName);
  U.User? _currentUserData;

  U.User? get userData {
    return _currentUserData;
  }

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
      final destination = '${Strings.bucketFireStorageName}/$fileName';

      final ref = _firebaseStorage.ref(destination);
      final task = await ref.putFile(photo);
      return await task.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveDataInPrefs(Object userData) async {
    try {
      final SP = await SharedPreferences.getInstance();
      final encodedData = json.encode(userData);
      final isSavedSuccessfully =
          await SP.setString(Strings.userDataKeySharedPrefrences, encodedData);
      if (isSavedSuccessfully == false) {
        throw Exception('Data Can\'t Saved Locally in this Device');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future _addUserToFireStore(U.User user) async {
    try {
      return await _usersCollection.add(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final userDataSnapShot =
          await _usersCollection.where('email', isEqualTo: email).get();
      final userData = userDataSnapShot.docs[0].data();
      if (userData == null) {
        throw FirebaseException(plugin: 'Can\'t find The User Data');
      }
      await _saveDataInPrefs(userData);
      final userDataAsMap = userData as Map;
      _currentUserData = U.User(
        imagePath: userDataAsMap['imagePath'],
        password: userDataAsMap['password'],
        age: userDataAsMap['age'],
        name: userDataAsMap['name'],
        weight: userDataAsMap['weight'],
        email: userDataAsMap['email'],
        height: userDataAsMap['height'],
      );
      await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signUp(U.User user) async {
    final userData = user.getUserData();
    try {
      final fileUrl = await _uploadFile(userData[U.UserDataEnum.image]);
      user.imagePath = fileUrl;
      await _addUserToFireStore(user);
      
      await _signUpWithEmailAndPassword(
        userData[U.UserDataEnum.email],
        userData[U.UserDataEnum.password],
      );

      await signIn(
        userData[U.UserDataEnum.email],
        userData[U.UserDataEnum.password],
      );
    }
    // on FirebaseAuthException catch (e) {
    //   var errMsg = 'Something Went Wrong';
    //   if (e.code == 'weak-password') {
    //     errMsg = 'The password provided is too weak.';
    //   } else if (e.code == 'email-already-in-use') {
    //     errMsg = 'The account already exists for that email.';
    //   }
    // }
    catch (e) {
      rethrow;
    }
  }

  void listenToUserStates(void Function(User?)? onData) =>
      _authInstance.authStateChanges().listen(onData);

  Future<void> signOut() async {
    await _authInstance.signOut();
  }
}
