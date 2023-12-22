import 'dart:io';
import 'package:evira/utils/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
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

  resetPassword(String email) async {
    await _authInstance.sendPasswordResetEmail(email: email);
  }

  Future<UserCredential> _signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _authInstance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.sendEmailVerification();
    return credential;
  }

  Future<String> _uploadFile(File photo) async {
    final fileName = basename(photo.path);
    final destination = '${Strings.bucketFireStorageName}/$fileName';

    final ref = _firebaseStorage.ref(destination);
    final task = await ref.putFile(photo);
    return await task.ref.getDownloadURL();
  }

  Future _addUserToFireStore(U.User user) async {
    return await _usersCollection.add(user.toJsonToFireStore());
  }

  Future<void> _deleteCurrenctUserImage(String imgUrl) async {
    final httpsReference = _firebaseStorage.refFromURL(imgUrl);
    await httpsReference.delete();
  }

  Future<void> updateUserData(U.User user) async {
    final userData = user.getUserData();
    if (userData[U.UserDataEnum.image] != null) {
      // Image Operation
      await _deleteCurrenctUserImage(user.getImagePath!);
      final fileUrl = await _uploadFile(userData[U.UserDataEnum.image]);
      user.imagePath = fileUrl;
    }

    // User Doc Operation
    final currentUserDocDatAndId =
        await getUserDatafromFireStore(user.getEmail!);
    print('................... currentUserDoc');
    print(currentUserDocDatAndId);
    final userDocId = currentUserDocDatAndId[1] as String;

    await _usersCollection.doc(userDocId).set(user.toJsonToFireStore());
  }

  Future<List<Object>> getUserDatafromFireStore(String email) async {
    final userDataSnapShot = await _usersCollection
        .where(
          'email',
          isEqualTo: email,
        )
        .get();
    if (userDataSnapShot.docs.isEmpty == true) {
      throw FirebaseException(plugin: 'Can\'t find The User Data');
    }
    final userData = userDataSnapShot.docs[0].data();
    if (userData == null) {
      throw FirebaseException(plugin: 'Can\'t find The User Data');
    }
    return [userDataSnapShot.docs[0].data()!, userDataSnapShot.docs[0].id];
  }

  Future<void> signIn(
    String email,
    String password,
    Future<void> Function(
      Object userData,
      String token, {
      bool? isSignIn,
    }) saveInPrefs,
  ) async {
    final credentials = await _authInstance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credentials.user?.emailVerified != true) {
      throw Exception('Verify Your Email Please...');
    }
    final userDataAndId = await getUserDatafromFireStore(email);
    final userData = userDataAndId[0];
    final token = await credentials.user!.getIdToken();
    await saveInPrefs(userData as Map, token!, isSignIn: true);
  }

  Future<bool> _isUserAlreadyExist(String email) async {
    final userQuerySnapshot =
        await _usersCollection.where('email', isEqualTo: email).get();
    if (userQuerySnapshot.docs.length.isEqual(0)) {
      return false;
    }
    return true;
  }

  Future<void> signUp(U.User user) async {
    final userData = user.getUserData();

    await _signUpWithEmailAndPassword(
      userData[U.UserDataEnum.email],
      userData[U.UserDataEnum.password],
    );
    final fileUrl = await _uploadFile(userData[U.UserDataEnum.image]);
    user.imagePath = fileUrl;
    await _addUserToFireStore(user);
  }

  Future<void> deleteAccount(U.User user) async {
    final userData = await getUserDatafromFireStore(user.getEmail!);
    await _deleteCurrenctUserImage(user.getImagePath!);
    await _usersCollection.doc(userData[1] as String).delete();
    await _authInstance.currentUser?.delete();
  }

  Future<void> signOut() async {
    await _authInstance.signOut();
  }
}
