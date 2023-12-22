import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/controllers/order-controller.dart';
import 'package:evira/controllers/products-controller.dart';
import 'package:evira/data/models/firebase-models/user-cart.dart';
import 'package:evira/data/models/orderd-product.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/data/repositories/cart-repo.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController get get => Get.find();
  late final CartRepo _cartRepo;
  UserCart? _currentUserCart;
  final Rx<bool> _isAbleToAddOrRemove = true.obs;

  Rx<bool> get isAbleToAddOrRemove {
    return Rx(_isAbleToAddOrRemove.value);
  }

  void resetIsAbleToAddOrRemove() {
    _isAbleToAddOrRemove.value = true;
  }

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
    _cartRepo = CartRepo.instance;
  }

  Future<void> addToCart(String productId) async {
    try {
      _isAbleToAddOrRemove.value = false;
      await _cartRepo.addToCartFromRepo(productId);

      if (_currentUserCart == null) {
        await getUserCart();
      }
      if (_currentUserCart!.cart[productId] == null) {
        _currentUserCart!.cart[productId] = 1;
        update([Strings.cartGetBuilderId]);
        return;
      }
      _currentUserCart!.cart[productId] =
          _currentUserCart!.cart[productId]! + 1;

      updateCartAmount();
      update([Strings.cartGetBuilderId]);
      _isAbleToAddOrRemove.value = true;
    } catch (e) {
      _isAbleToAddOrRemove.value = true;
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
      _isAbleToAddOrRemove.value = false;
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
      _isAbleToAddOrRemove.value = true;
    } catch (e) {
      _isAbleToAddOrRemove.value = true;
      rethrow;
    }
  }

  Future<void> removeFromCart(
    String productId, {
    void Function()? onDone,
  }) async {
    try {
      _isAbleToAddOrRemove.value = false;

      await _cartRepo.removeFromCartFromRepo(productId);
      if (_currentUserCart?.cart[productId] == 1) {
        _currentUserCart?.cart.remove(productId);
        _cartProducts.removeWhere(
          (element) =>
              Product.fromJson(element.data() as Map).id ==
              int.parse(productId),
        );
      } else {
        _currentUserCart?.cart[productId] =
            _currentUserCart!.cart[productId]! - 1;
      }

      if (onDone != null) {
        onDone();
      }
      updateCartAmount();
      update([Strings.cartGetBuilderId]);
      _isAbleToAddOrRemove.value = true;
    } catch (e) {
      _isAbleToAddOrRemove.value = true;
      rethrow;
    }
  }

  void resetDefaults() {
    _cartAmount = 0;
    _cartProducts = [];
    update([Strings.cartGetBuilderId]);
  }

  Future<void> getUserCart() async {
    try {
      resetDefaults();
      final gettedUserCart = await _cartRepo.getUserCartFromRepo();
      if (gettedUserCart == null || gettedUserCart.cart.isEmpty) {
        return;
      }
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
    if (_cartProducts.isEmpty || _currentUserCart == null) {
      _cartAmount = 0;
      return;
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

  List<OrderedProduct> _prepareOrderProducts() {
    final List<OrderedProduct> result = [];
    try {
      for (var i = 0; i < _cartProducts.length; i++) {
        final currentProduct = _cartProducts[i].data() as Map<String, dynamic>;
        final currentProductQuantity =
            _currentUserCart?.cart[currentProduct['id'].toString()];
        print(_currentUserCart?.cart);
        print(' ................. currentProductQuantity ....................');
        print(currentProductQuantity);
        final orderedProduct = OrderedProduct.fromJson(
          currentProduct,
          quantity: currentProductQuantity,
        );
        print(orderedProduct);
        result.add(orderedProduct);
      }
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future<void> makeOrder() async {
    try {
      final orderdProducts = _prepareOrderProducts();
      print('GOT HERE');
      await OrderController.get.addOrder(orderdProducts, _cartAmount);
      print('GOT HERE');
      await _cartRepo.cleanUpUserCart();
      _currentUserCart?.cart = {};
      _cartProducts = [];
      _cartAmount = 0;
      update([Strings.cartGetBuilderId]);
    } catch (e) {
      rethrow;
    }
  }

  resetCartController() {
    _cartAmount = 0;
    _cartProducts = [];
    _currentUserCart = null;
  }
}
