import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/data/models/firebase-models/user-orders.dart';
import 'package:evira/data/models/orderd-product.dart';
import 'package:evira/data/models/user.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:get/get.dart';
import '../models/firebase-models/order.dart' as FSO;

class OrderDS {
  final CollectionReference _orderCollection =
      FirebaseFirestore.instance.collection(Strings.orderCollectionName);

  Future<void> addOrder(
    String userEmail,
    List<OrderedProduct> products,
    double totalAmount,
  ) async {
    try {
      final FSO.Order thePreparedOrder = FSO.Order(
        date: DateTime.now().toIso8601String(),
        products: products,
        totalPrice: totalAmount,
      );
      var userOrders = await getOrders(userEmail);

      if (userOrders != null) {
        final currentOrders = UserOrders.fromJson(
          userOrders.data() as Map<String, dynamic>,
        );
        currentOrders.orders[DateTime.now().toString()] = thePreparedOrder;
        await _orderCollection.doc(userOrders.id).set(currentOrders.toJson());
        return;
      }
      final newUserOrders = UserOrders(
        orders: {DateTime.now().toString(): thePreparedOrder},
        email: userEmail,
      );
      await _orderCollection.add(newUserOrders.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<QueryDocumentSnapshot<Object?>?> getOrders(String userEmail) async {
    try {
      final userQuerySnapshot = await _orderCollection
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

  Future<void> deleteUserOrders(User user) async {
    final userData = await getOrders(user.getEmail!);
    if (userData == null) {
      return;
    }
    await _orderCollection.doc(userData.id).delete();
  }
}
