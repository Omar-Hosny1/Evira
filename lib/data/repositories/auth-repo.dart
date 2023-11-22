import 'package:evira/data/data-sources/auth-ds.dart';
import 'package:evira/data/models/user.dart';

class AuthRepo {
  final AuthDS authDataSource;
  AuthRepo({required this.authDataSource});

  signUp(User user) {
    try {
      authDataSource.signUp(user);
    } catch (e) {}
  }
}
