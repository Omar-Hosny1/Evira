import 'package:evira/data/data-sources/cart-ds.dart';
import 'package:evira/data/repositories/cart-repo.dart';
import 'package:evira/utils/helpers/snack-bar.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get get => Get.find();
  late final CartRepo _cartRepo;

  @override
  void onInit() {
    super.onInit();
    _cartRepo = CartRepo(CartDS());
  }

  Future<void> addToCart(String productId) async {
    try {
      await _cartRepo.addToCartFromRepo(productId);
    } catch (e) {
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', e.toString());
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      await _cartRepo.removeFromCartFromRepo(productId);
    } catch (e) {
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', e.toString());
    }
  }

  Future<void> getUserCart() async {
    try {
      final userCart = await _cartRepo.getUserCartFromRepo();
      if (userCart == null) {
        print('******************** userCart is Null ********************');
        return;
      }
    } catch (e) {
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', e.toString());
    }
  }
}
