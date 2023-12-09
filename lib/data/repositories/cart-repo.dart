import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/data/data-sources/cart-ds.dart';
import 'package:evira/data/models/firebase-models/user-cart.dart';
import 'package:evira/utils/helpers/error-handler.dart';

class CartRepo {
  final CartDS cartDs;
  CartRepo(this.cartDs);

  Future<void> addToCartFromRepo(String productId) async {
    await errorHandler(tryLogic: () async {
      final userEmail = AuthController.get.userData!.getEmail!;
      await cartDs.addToCart(userEmail, productId);
    });
  }

  Future<void> removeFromCartFromRepo(String productId) async {
    await errorHandler(tryLogic: () async {
      final userEmail = AuthController.get.userData!.getEmail!;
      await cartDs.removeFromCart(userEmail, productId);
    });
  }

  Future<void> removeFromCartPermanently(String productId) async {
    await errorHandler(tryLogic: () async {
      final userEmail = AuthController.get.userData!.getEmail!;
      await cartDs.removeFromCartPermanently(userEmail, productId);
    });
  }

  Future<UserCart?> getUserCartFromRepo() async {
    return await errorHandler<UserCart?>(tryLogic: () async {
      final userEmail = AuthController.get.userData!.getEmail!;
      final userCartDoc = await cartDs.getUserCart(userEmail);
      if (userCartDoc == null) {
        return null;
      }
      final userCartData = userCartDoc.data() as Map<String, dynamic>;
      print('*************************** UserCart ***************** ');
      print(UserCart.fromJson(userCartData).toJson());
      return UserCart.fromJson(userCartData);
    });
  }
}
