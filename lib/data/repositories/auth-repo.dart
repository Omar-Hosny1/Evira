import 'package:evira/data/data-sources/auth-ds.dart';
import 'package:evira/data/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as FA;

class AuthRepo {
  final AuthDS authDataSource;
  AuthRepo({required this.authDataSource});

  listenToUserStates(void Function(FA.User?)? onData) {
    authDataSource.listenToUserStates(onData);
  }

  Future<void> logout() async {
    await authDataSource.signOut();
  }

  Future<void> signUp(User user) async {
    print('CALLED 2');
    try {
      await authDataSource.signUp(user);
    } catch (e) {
      print(e);
    }
  }
}
