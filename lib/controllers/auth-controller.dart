import 'package:evira/data/data-sources/auth-ds.dart';
import 'package:evira/data/models/user.dart';
import 'package:evira/data/repositories/auth-repo.dart';
import 'package:evira/views/screens/auth/sign-up.dart';
import 'package:evira/views/screens/home.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late final AuthRepo _authRepository;
  static AuthController get get => Get.find(); 
  
  
  @override
  void onInit() {
    listenToUserStates();
  }

  AuthController() {
    _authRepository = AuthRepo(authDataSource: AuthDS());
  }

  Future<void> signUp(User user) async {
    await _authRepository.signUp(user);
  }

  listenToUserStates() {
    _authRepository.listenToUserStates((user) async {
      if (user == null) {
        Get.offAllNamed(SignUp.routeName);
        return;
      }
      Get.offAllNamed(Home.routeName);
    });
  }

  Future<void> logOut() async {
    await _authRepository.logout();
  }
}
