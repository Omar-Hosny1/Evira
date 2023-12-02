import 'dart:async';

import 'package:evira/data/data-sources/auth-ds.dart';
import 'package:evira/data/models/user.dart';
import 'package:evira/data/repositories/auth-repo.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/utils/helpers/snack-bar.dart';
import 'package:evira/views/screens/auth/sign-in.dart';
import 'package:evira/views/screens/auth/sign-up.dart';
import 'package:evira/views/screens/home.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  late final AuthRepo _authRepository;
  static AuthController get get => Get.find();
  User? userData;
  Timer? _authTimer;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // getInitialRoute();
  // }

  AuthController() {
    _authRepository = AuthRepo(authDataSource: AuthDS());
  }

  Future<void> signUp(User user) async {
    try {
      await _authRepository.signUp(user);
      Get.offAllNamed(SignIn.routeName);
      showSnackbar(
        SnackbarState.success,
        'Welcome To Evira..',
        'Signed in Now',
      );
    } catch (e) {
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', e.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _authRepository.signIn(email, password);
      Get.offAllNamed(Home.routeName);
      await _getUserDataFromPrefsAndSetCurrentUserData();
      showSnackbar(SnackbarState.success, 'Success', 'Logged in Successfully');
    } catch (e) {
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', e.toString());
    }
  }

  Future<void> _getUserDataFromPrefsAndSetCurrentUserData() async {
    final getedUserData = await _authRepository.getUserDataFromSharedPrefs();
    print('***************** getedUserData *****************');
    print(getedUserData);
    userData = getedUserData;
    _autoLogOut(DateTime.parse(getedUserData!.getTokenExpiresIn!));

    update([Strings.userListTileGetBuilderId]);
    print('****************** userData ******************');
    print(userData!.getUserData());
  }

  Future<String> getInitialRoute() async {
    final gettedUserDataFromShared =
        await _authRepository.getUserDataFromSharedPrefs();
    if (gettedUserDataFromShared == null ||
        gettedUserDataFromShared.getTokenExpiresIn == null ||
        gettedUserDataFromShared.getToken == null) {
      return SignUp.routeName;
    }

    final expiresIn =
        DateTime.parse(gettedUserDataFromShared.getTokenExpiresIn!);

    if (expiresIn.isBefore(DateTime.now())) {
      return SignUp.routeName;
    }
    await _getUserDataFromPrefsAndSetCurrentUserData();
    return Home.routeName;
  }

  // _authRepository.listenToUserStates((user) {
  //   if (user == null) {
  //     _authRepository.cleanUserDataFromSharedPrefs().then(
  //           (_) => Get.offAllNamed(SignUp.routeName),
  //         );

  //     print('**************** LOGGED OUT ****************');
  //     return;
  //   }
  //   _getUserDataFromPrefsAndSetCurrentUserData().then((_) {
  //     print('**************** LOGGED IN ****************');
  //     Get.offAllNamed(Home.routeName);
  //   });
  // });

  void _autoLogOut(DateTime? expiryDate) {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    if (expiryDate == null) {
      return;
    }
    final timeToExpiry = expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(
      Duration(seconds: timeToExpiry),
      () {
        logOut();
        showSnackbar(SnackbarState.success, 'Sign in Again Now',
            'Your Token Had Expired');
      },
    );
  }

  Future<void> logOut() async {
    userData = null;
    update([Strings.userListTileGetBuilderId]);
    await _authRepository.logout();
    Get.offAllNamed(SignUp.routeName);
  }
}
