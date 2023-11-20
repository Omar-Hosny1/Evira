import 'package:evira/views/screens/home.dart';
import 'package:get/get.dart';

class Routes {
  Routes._();
  static final routes = [
    GetPage(
      name: Home.routeName,
      page: () => const Home(),
    ),
  ];
}
