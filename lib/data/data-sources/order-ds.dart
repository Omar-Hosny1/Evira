import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/data/models/firebase-models/user-orders.dart';
import 'package:evira/data/models/orderd-product.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:get/get.dart';
import '../models/firebase-models/order.dart' as FSO;

class OrderDS {
  final CollectionReference _cartCollection =
      FirebaseFirestore.instance.collection(Strings.orderCollectionName);

  Future<void> addOrder(
    String userEmail,
    List<OrderedProduct> products,
    double totalAmount,
  ) async {
    print('SO ON');
    try {
      final FSO.Order thePreparedOrder = FSO.Order(
        date: DateTime.now().toIso8601String(),
        products: products,
        totalPrice: totalAmount,
      );
      print('SO ON 1');
      var userOrders = await getOrders(userEmail);

      if (userOrders != null) {
        final currentOrders = UserOrders.fromJson(
          userOrders.data() as Map<String, dynamic>,
        );
        print('SO ON 2');
        currentOrders.orders[DateTime.now().toString()] = thePreparedOrder;
        print(currentOrders.toJson()); 

        await _cartCollection.doc(userOrders.id).set(currentOrders.toJson());
        return;
      }
      final newUserOrders = UserOrders(
        orders: {DateTime.now().toString(): thePreparedOrder},
        email: userEmail,
      );
      await _cartCollection.add(newUserOrders.toJson());
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
