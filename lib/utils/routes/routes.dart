import 'package:evira/views/screens/auth/sign-in.dart';
import 'package:evira/views/screens/auth/sign-up.dart';
import 'package:evira/views/screens/home.dart';
import 'package:evira/views/screens/product-details.dart';
import 'package:evira/views/screens/splash.dart';
import 'package:evira/views/screens/wishlist.dart';
import 'package:get/get.dart';

class Routes {
  Routes._();
  static final routes = [
    GetPage(
      name: SignUp.routeName,
      page: () => SignUp(),
    ),
    GetPage(
      name: SignIn.routeName,
      page: () => SignIn(),
    ),
    GetPage(
      name: Home.routeName,
      page: () => Home(),
    ),
    GetPage(
      name: ProductDetails.routeName,
      page: () => ProductDetails(),
    ),
    GetPage(
      name: Splash.routeName,
      page: () => Splash(),
    ),
    GetPage(
      name: Wishlist.routeName,
      page: () => Wishlist(),
    ),
  ];
}
