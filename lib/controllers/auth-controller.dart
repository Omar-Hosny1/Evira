import 'package:evira/data/data-sources/auth-ds.dart';
import 'package:evira/data/models/user.dart';
import 'package:evira/data/repositories/auth-repo.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late final AuthRepo _authRepository;
  AuthController() {
    _authRepository = AuthRepo(authDataSource: AuthDS());
  }


  Future<void> signUp(User user)async {
    await _authRepository.signUp(user);
  }
}
