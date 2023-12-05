import 'package:evira/controllers/products-controller.dart';
import 'package:evira/data/data-sources/cart-ds.dart';
import 'package:evira/data/models/firebase-models/user-cart.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/data/repositories/cart-repo.dart';
import 'package:evira/utils/helpers/snack-bar.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get get => Get.find();
  late final CartRepo _cartRepo;
  UserCart? _currentUserCart;
  List<Product> _cartProducts = [];

  List<Product> get cartProducts {
    return _cartProducts;
  }

  UserCart? get currentUserCart {
    return _currentUserCart;
  }

  @override
  void onInit() async {
    super.onInit();
    _cartRepo = CartRepo(CartDS());
  }

  @override
  @override
  void onClose() {
    // time to close some resources and to do other cleanings
    print('****************** CLOSED **************');
    _currentUserCart = null;
    _cartProducts = [];
  }

  Future<void> addToCart(String productId, {void Function()? onDone}) async {
    try {
      await _cartRepo.addToCartFromRepo(productId);
      await getUserCart();
      if (onDone != null) {
        onDone();
      }
    } catch (e) {
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', e.toString());
    }
  }

  Future<void> removeFromCart(String productId,
      {void Function()? onDone}) async {
    try {
      await _cartRepo.removeFromCartFromRepo(productId);
      await getUserCart();
      if (onDone != null) {
        onDone();
      }
    } catch (e) {
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', e.toString());
    }
  }

  Future<void> getUserCart() async {
    try {
      final gettedUserCart = await _cartRepo.getUserCartFromRepo();
      if (gettedUserCart == null) {
        print(
            '******************** gettedUserCart is Null ********************');
        return;
      }
      print('************ gettedUserCart *************');
      print(gettedUserCart.toJson());
      _currentUserCart = gettedUserCart;

      _cartProducts = ProductController.get.getCartProducts(
        gettedUserCart.cart,
      );
      // update();
    } catch (e) {
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', e.toString());
    }
  }
}
