import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/data/models/user.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:get/get.dart';

class CartDS {
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection(Strings.cartCollectionName);

  Future<void> addToCart(String userEmail, String productId) async {
    try {
      final userCart = await getUserCart(userEmail);
      if (userCart != null) {
        final currentCart = (userCart.data()
            as Map)[Strings.productsMapKeyForCartDocument] as Map;
        if (currentCart[productId] != null) {
          final updatedCart = {
            ...currentCart,
            productId: currentCart[productId] + 1
          };
          await _cartCollection.doc(userCart.id).update(
            {Strings.productsMapKeyForCartDocument: updatedCart},
          );
          return;
        }
        final updatedCart = {...currentCart, productId: 1};
        await _cartCollection.doc(userCart.id).update(
          {Strings.productsMapKeyForCartDocument: updatedCart},
        );
        return;
      }
      await _cartCollection.add({
        Strings.userEmailKeyForCartDocument: userEmail,
        Strings.productsMapKeyForCartDocument: {productId: 1},
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromCartPermanently(
    String userEmail,
    String productId,
  ) async {
    try {
      final userCart = await getUserCart(userEmail);
      if (userCart == null) {
        return;
      }
      final currentCart = (userCart.data()
          as Map)[Strings.productsMapKeyForCartDocument] as Map;

      if (currentCart[productId] == null) {
        return;
      }
      currentCart.remove(productId);
      await _cartCollection.doc(userCart.id).update(
        {Strings.productsMapKeyForCartDocument: currentCart},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromCart(String userEmail, String productId) async {
    try {
      final userCart = await getUserCart(userEmail);
      if (userCart == null) {
        return;
      }
      final currentCart = (userCart.data()
          as Map)[Strings.productsMapKeyForCartDocument] as Map;
      if (currentCart[productId] == null) {
        return;
      }
      if (currentCart[productId] == 1) {
        currentCart.remove(productId);
        await _cartCollection.doc(userCart.id).update(
          {Strings.productsMapKeyForCartDocument: currentCart},
        );
        return;
      }
      currentCart[productId] = currentCart[productId] - 1;
      await _cartCollection.doc(userCart.id).update(
        {Strings.productsMapKeyForCartDocument: currentCart},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<QueryDocumentSnapshot<Object?>?> getUserCart(String userEmail) async {
    try {
      final userQuerySnapshot = await _cartCollection
          .where(Strings.userEmailKeyForWishlistDocument, isEqualTo: userEmail)
          .get();
      if (userQuerySnapshot.docs.length.isEqual(0)) {
        return null;
      }
      return userQuerySnapshot.docs[0];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cleanUpUserCart(String userEmail) async {
    try {
      final userCart = await getUserCart(userEmail);
      if (userCart == null) {
        return;
      }

      await _cartCollection.doc(userCart.id).update(
        {
          Strings.productsMapKeyForCartDocument: {},
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserCart(User user) async {
    final userData = await getUserCart(user.getEmail!);
    if (userData == null) {
      return;
    }
    await _cartCollection.doc(userData.id).delete();
  }
}
