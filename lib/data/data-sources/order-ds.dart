import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:get/get.dart';

class OrderDS {
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection(Strings.orderCollectionName);

// {'ue':'', orders : {550 : []}}
  Future<void> addOrder(String userEmail, List<Product> products) async {
    try {
      final userOrders = await getOrders(userEmail);
      if (userOrders != null) {}
    } catch (e) {
      rethrow;
    }
  }

  Future<QueryDocumentSnapshot<Object?>?> getOrders(String userEmail) async {
    try {
      final userQuerySnapshot = await _cartCollection
          .where(Strings.userEmailKeyForOrderDocument, isEqualTo: userEmail)
          .get();
      if (userQuerySnapshot.docs.length.isEqual(0)) {
        return null;
      }
      return userQuerySnapshot.docs[0];
    } catch (e) {
      rethrow;
    }
  }
}
