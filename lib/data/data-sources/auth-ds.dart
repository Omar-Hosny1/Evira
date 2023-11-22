import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as U;
class AuthDS {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  Future<dynamic> signUp(U.User user) async {
    final userData = user.getUserData();
    try {
      final credential = await _authInstance.createUserWithEmailAndPassword(
        email: userData[U.UserDataEnum.email],
        password: userData[U.UserDataEnum.password],
      );
      print("***************** credential *****************");
      print(credential);
      checkIfTheUserSignedIn();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  checkIfTheUserSignedIn() {
    _authInstance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  signOut() async {
    await _authInstance.signOut();
  }
}
