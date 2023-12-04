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
      print('******************* addToWishlist CALLED ********************');
      // Has Wishlist
      if (userWishlist != null) {
        print('****************** HAS Wishlist ******************');
        final currentWishlist = (userWishlist.data()
            as Map)[Strings.productsMapKeyForWishlistDocument] as Map;
        print('****************** currentWishlist ******************');
        print(currentWishlist);
        if (currentWishlist[productId] == true) {
          return;
        }
        final updatedWishList = {...currentWishlist, productId: true};
        print('****************** updatedWishList ******************');
        print(updatedWishList);
        await _wishlistCollection.doc(userWishlist.id).update(
          {Strings.productsMapKeyForWishlistDocument: updatedWishList},
        );
        return;
      }
      print('*************** ADDING ***************');
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
      print('****************** HAS Wishlist ******************');
      final currentWishlist = (userWishlist.data()
          as Map)[Strings.productsMapKeyForWishlistDocument] as Map;
      print('****************** currentWishlist ******************');
      print(currentWishlist);
      ;
      currentWishlist.remove(productId);
      print(
          '****************** currentWishlist AFTER DELETE ******************');
      print(currentWishlist);
      await _wishlistCollection.doc(userWishlist.id).update(
        {Strings.productsMapKeyForWishlistDocument: currentWishlist},
      );
    } catch (e) {
      rethrow;
    }
  }
}
