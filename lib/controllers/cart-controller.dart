import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/controllers/products-controller.dart';
import 'package:evira/data/data-sources/cart-ds.dart';
import 'package:evira/data/models/firebase-models/user-cart.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/data/repositories/cart-repo.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get get => Get.find();
  late final CartRepo _cartRepo;
  UserCart? _currentUserCart;
  List<QueryDocumentSnapshot<Object?>> _cartProducts = [];
  double _cartAmount = 0;

  double get cartAmount => _cartAmount;

  List<QueryDocumentSnapshot<Object?>> get cartProducts {
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
      print('************* _currentUserCart ****************');
      print(_currentUserCart);
      if (_currentUserCart == null) {
        await getUserCart();
      }
      if (_currentUserCart!.cart[productId] == null) {
        _currentUserCart!.cart[productId] = 1;
        update([Strings.cartGetBuilderId]);
        if (onDone != null) {
          onDone();
        }
        return;
      }
      _currentUserCart!.cart[productId] =
          _currentUserCart!.cart[productId]! + 1;
      if (onDone != null) {
        onDone();
      }
      updateCartAmount();
      update([Strings.cartGetBuilderId]);
    } catch (e) {
      rethrow;
    }
  }

  int getProductQuantity(String id) {
    return currentUserCart?.cart[id] ?? 0;
  }

  Future<void> removeFromCartPermanently(
    String productId, {
    void Function()? onDone,
  }) async {
    try {
      await _cartRepo.removeFromCartPermanently(productId);
      _currentUserCart?.cart.remove(productId);
      _cartProducts.removeWhere(
        (element) =>
            Product.fromJson(element.data() as Map).id ==
            int.parse(
              productId,
            ),
      );

      if (onDone != null) {
        onDone();
      }
      updateCartAmount();
      update([Strings.cartGetBuilderId]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromCart(
    String productId, {
    void Function()? onDone,
  }) async {
    try {
      await _cartRepo.removeFromCartFromRepo(productId);
      if (_currentUserCart?.cart[productId] == 1) {
        _currentUserCart?.cart.remove(productId);
        _cartProducts.removeWhere(
          (element) =>
              Product.fromJson(element.data() as Map).id ==
              int.parse(productId),
        );
      } else {
        print(_currentUserCart?.cart[productId]);
        _currentUserCart?.cart[productId] =
            _currentUserCart!.cart[productId]! - 1;
        print(_currentUserCart?.cart[productId]);
      }

      if (onDone != null) {
        onDone();
      }
      updateCartAmount();
      update([Strings.cartGetBuilderId]);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getUserCart() async {
    try {
      final gettedUserCart = await _cartRepo.getUserCartFromRepo();
      if (gettedUserCart == null || gettedUserCart.cart.isEmpty) {
        print(
          '******************** gettedUserCart is Null ********************',
        );
        return;
      }
      print('************ gettedUserCart *************');
      print(gettedUserCart.toJson());
      _currentUserCart = gettedUserCart;

      final data = await ProductController.get.getCartProducts(
        gettedUserCart.cart.keys.map((e) => int.parse(e)).toList(),
      );
      _cartProducts = data.docs;
      updateCartAmount();
      update([Strings.cartGetBuilderId]);
    } catch (e) {
      rethrow;
    }
  }

  void updateCartAmount() {
    if (_cartProducts.length == 0 || _currentUserCart == null) {
      _cartAmount = 0;
    }
    double amount = 0;
    for (var i = 0; i < _cartProducts.length; i++) {
      final currentProduct = Product.fromJson(_cartProducts[i].data() as Map);
      final currentProductAmount =
          _currentUserCart!.cart[currentProduct.id.toString()] ?? 0;
      amount += currentProduct.price * currentProductAmount;
    }
    _cartAmount = amount;
  }
}
