import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/data/data-sources/order-ds.dart';
import 'package:evira/data/models/firebase-models/user-orders.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/utils/helpers/error-handler.dart';

class OrderRepo {
  final OrderDS orderDS;
  OrderRepo({required this.orderDS});

  Future<void> addOrderFromRepo(List<Product> products, int totalAmount) async {
    await errorHandler(tryLogic: () async {
      final userEmail = AuthController.get.userData!.getEmail!;
      await orderDS.addOrder(userEmail, products, totalAmount);
    });
  }

  Future<UserOrders?> getUserOrdersFromRepo() async {
    return await errorHandler<UserOrders?>(tryLogic: () async {
      final userEmail = AuthController.get.userData!.getEmail!;
      final gettedUserOrders = await orderDS.getOrders(userEmail);
      if (gettedUserOrders == null) {
        return null;
      }
      return UserOrders.fromJson(
        gettedUserOrders.data() as Map<String, dynamic>,
      );
    });
  }
}
