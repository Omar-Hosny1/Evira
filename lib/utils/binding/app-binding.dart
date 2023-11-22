import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/controllers/products-controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(() => ProductController());
    Get.put(AuthController(), permanent: true);
  }
}
