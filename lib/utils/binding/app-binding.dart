import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/controllers/products-controller.dart';
import 'package:evira/controllers/wishlist-controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(ProductController(), permanent: true);
    Get.put(WishlistController(), permanent: true);
  }
}
