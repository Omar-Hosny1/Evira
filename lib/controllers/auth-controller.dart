import 'dart:async';

import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/controllers/products-controller.dart';
import 'package:evira/controllers/wishlist-controller.dart';
import 'package:evira/data/models/user.dart';
import 'package:evira/data/repositories/auth-repo.dart';
import 'package:evira/data/repositories/cart-repo.dart';
import 'package:evira/data/repositories/order-repo.dart';
import 'package:evira/data/repositories/wishlist-repo.dart';
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
  @override
  void onClose() {
    // time to close some resources and to do other cleanings
    userData = null;
    _authTimer = null;
    print('****************** CLOSED **************');
  }

  AuthController() {
    _authRepository = AuthRepo.instance;
  }

  Future<void> signUp(User user) async {
    try {
      await _authRepository.signUp(user);
      Get.offAllNamed(SignIn.routeName);
      showSnackbar(
        SnackbarState.success,
        'Verify Your Email To Signin',
        'Check your email...',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _authRepository.signIn(email, password);
      await _getUserDataFromPrefsAndSetCurrentUserData();
      await ProductController.get.fetchCartAndWishlistData();

      Get.offAllNamed(Home.routeName);
      showSnackbar(SnackbarState.success, 'Success', 'Logged in Successfully');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserData(User user) async {
    try {
      await _authRepository.updateUserData(user);
      await _getUserDataFromPrefsAndSetCurrentUserData();
      update([Strings.userListenersGetBuilderId]);
      print('................. user.toJson() ................');
      print(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _getUserDataFromPrefsAndSetCurrentUserData() async {
    final getedUserData = await _authRepository.getUserDataFromSharedPrefs();
    print('***************** getedUserData *****************');
    print(getedUserData);
    userData = getedUserData;
    _autoLogOut(DateTime.parse(getedUserData!.getTokenExpiresIn!));

    update([Strings.userListenersGetBuilderId]);
    print('****************** userData ******************');
    print(userData!.getUserData());
  }

  bool wasSignedIn(User? user) {
    if (user == null ||
        user.getTokenExpiresIn == null ||
        user.getToken == null) {
      return false;
    }
    final expiresIn = DateTime.parse(user.getTokenExpiresIn!);

    if (expiresIn.isBefore(DateTime.now())) {
      return false;
    }
    return true;
  }

  Future<String> getInitialRoute() async {
    try {
      final gettedUserDataFromShared =
          await _authRepository.getUserDataFromSharedPrefs();
      if (wasSignedIn(gettedUserDataFromShared) == false) {
        await _authRepository.cleanUserDataFromSharedPrefs();

        resetAllPermenanrControllers();
        return SignUp.routeName;
      }

      await _getUserDataFromPrefsAndSetCurrentUserData();
      await ProductController.get.fetchCartAndWishlistData();
      return Home.routeName;
    } catch (e) {
      await _authRepository.cleanUserDataFromSharedPrefs();
      resetAllPermenanrControllers();
      return SignUp.routeName;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authRepository.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }

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
        showSnackbar(
          SnackbarState.success,
          'Sign in Again Now',
          'Your Token Had Expired',
        );
      },
    );
  }

  void resetAllPermenanrControllers() {
    ProductController.get.resetProductsController();
    CartController.get.resetCartController();
    WishlistController.get.resetWishlistController();
    resetAuthController();
  }

  Future<void> logOut() async {
    await _authRepository.logout();
    resetAllPermenanrControllers();
    Get.offAllNamed(SignUp.routeName);
    userData = null;
    _authTimer = null;
  }

  resetAuthController() {
    userData = null;
    _authTimer = null;
  }

  Future<void> deleteAccount() async {
    print('GOT HERE 1');
    await CartRepo.instance.deleteUserCart();
    print('GOT HERE 2');
    await OrderRepo.instance.deleteUserOrders();
    print('GOT HERE 3');
    await WishlistRepo.instance.deleteUserOrders();
    print('GOT HERE 4');
    await _authRepository.deleteAccount();
    print('GOT HERE 5');
    await _authRepository.cleanUserDataFromSharedPrefs();

    resetAllPermenanrControllers();
    Get.offAllNamed(SignUp.routeName);
  }
}
