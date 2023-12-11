import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:get/get.dart';

class WishlistDS {
  final CollectionReference _wishlistCollection =
      FirebaseFirestore.instance.collection(Strings.wishlistCollectionName);
      
  Future<QueryDocumentSnapshot<Object?>?> getUserWishlist(
    String userEmail,
  ) async {
    try {
      final userQuerySnapshot = await _wishlistCollection
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

  Future<void> addToWishlist(String userEmail, String productId) async {
    try {
      final userWishlist = await getUserWishlist(userEmail);
      if (userWishlist != null) {
        final currentWishlist = (userWishlist.data()
            as Map)[Strings.productsMapKeyForWishlistDocument] as Map;
        if (currentWishlist[productId] == true) {
          return;
        }
        final updatedWishList = {...currentWishlist, productId: true};
        await _wishlistCollection.doc(userWishlist.id).update(
          {Strings.productsMapKeyForWishlistDocument: updatedWishList},
        );
        return;
      }
      await _wishlistCollection.add({
        Strings.userEmailKeyForWishlistDocument: userEmail,
        Strings.productsMapKeyForWishlistDocument: {productId: true},
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromWishlist(String userEmail, String productId) async {
    try {
      final userWishlist = await getUserWishlist(userEmail);
      if (userWishlist == null) {
        return;
      }
      final currentWishlist = (userWishlist.data()
          as Map)[Strings.productsMapKeyForWishlistDocument] as Map;
      currentWishlist.remove(productId);
      await _wishlistCollection.doc(userWishlist.id).update(
        {Strings.productsMapKeyForWishlistDocument: currentWishlist},
      );
    } catch (e) {
      print('ERROR ${e.toString()}');
      rethrow;
    }
  }
}
