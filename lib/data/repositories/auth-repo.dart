import 'package:evira/data/data-sources/auth-ds.dart';
import 'package:evira/data/models/user.dart';

class AuthRepo {
  final AuthDS authDataSource;
  AuthRepo({required this.authDataSource});

  Future<void> signUp(User user) async{
    print('CALLED 2');
    try {
      await authDataSource.signUp(user);
    } catch (e) {
      print(e);
    }
  }
}
