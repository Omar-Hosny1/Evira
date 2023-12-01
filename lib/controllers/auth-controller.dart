import 'package:evira/data/data-sources/auth-ds.dart';
import 'package:evira/data/models/user.dart';
import 'package:evira/data/repositories/auth-repo.dart';
import 'package:evira/utils/helpers/snack-bar.dart';
import 'package:evira/views/screens/auth/sign-up.dart';
import 'package:evira/views/screens/home.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late final AuthRepo _authRepository;
  static AuthController get get => Get.find();
  final Rx<User?> _userData = Rx(null);

  User? get userData {
    return _userData.value;
  }

  @override
  void onInit() {
    super.onInit();
    listenToUserStates();
  }

  AuthController() {
    _authRepository = AuthRepo(authDataSource: AuthDS());
  }

  Future<void> signUp(User user) async {
    try {
      await _authRepository.signUp(user);
      await _getUserDataFromPrefsAndSetCurrentUserData();
    } catch (e) {
      print('************* SHOWING SNACKBAR *************');
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', 'e.toString()');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _authRepository.signIn(email, password);
    } catch (e) {
      print('************* SHOWING SNACKBAR *************');
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', 'e.toString()');
    }
  }

  Future<void> _getUserDataFromPrefsAndSetCurrentUserData() async {
    final getedUserData = await _authRepository.getUserDataFromSharedPrefs();
    _userData.value = getedUserData;
  }

  listenToUserStates() {
    _authRepository.listenToUserStates((user) async {
      if (user == null) {
        _authRepository.cleanUserDataFromSharedPrefs();
        Get.offAllNamed(SignUp.routeName);
        return;
      }
      await _getUserDataFromPrefsAndSetCurrentUserData();
      Get.offAllNamed(Home.routeName);
    });
  }

  Future<void> logOut() async {
    await _authRepository.logout();
  }
}
