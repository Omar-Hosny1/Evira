import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:get/get.dart';

class CartDS {
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection(Strings.cartCollectionName);

  Future<void> addToCart(String userEmail, String productId) async {
    try {
      final userCart = await getUserCart(userEmail);
      print('******************* addToCart CALLED ********************');
      // Has Wishlist
      if (userCart != null) {
        print('****************** HAS Cart ******************');
        final currentCart = (userCart.data()
            as Map)[Strings.productsMapKeyForCartDocument] as Map;
        print('****************** currentCart ******************');
        print(currentCart);
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
        print('****************** updatedCart ******************');
        print(updatedCart);
        await _cartCollection.doc(userCart.id).update(
          {Strings.productsMapKeyForCartDocument: updatedCart},
        );
        return;
      }
      print('*************** ADDING ***************');
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
      print('****************** HAS Cart ******************');
      final currentCart = (userCart.data()
          as Map)[Strings.productsMapKeyForCartDocument] as Map;
      print('****************** currentCart ******************');
      print(currentCart);
      if (currentCart[productId] == null) {
        return;
      }
      if (currentCart[productId] == 1) {
        currentCart.remove(productId);
        print('****************** currentCart AFTER DELETE ******************');
        print(currentCart);
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
      print('******************* userQuerySnapshot *******************');
      print(userQuerySnapshot.docs[0].data());
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
}
