import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/data/data-sources/order-ds.dart';
import 'package:evira/data/models/firebase-models/user-orders.dart';
import 'package:evira/data/models/orderd-product.dart';
import 'package:evira/utils/constants/values.dart';
import 'package:evira/utils/helpers/error-handler.dart';

class OrderRepo {
  final OrderDS orderDS;
  OrderRepo._(this.orderDS);

  static OrderRepo? _instance;

  static OrderRepo get instance {
    _instance ??= OrderRepo._(OrderDS());
    return _instance!;
  }

  Future<void> addOrderFromRepo(
    List<OrderedProduct> products,
    double totalAmount,
  ) async {
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

  Future<void> deleteUserOrders() async {
    await errorHandler(
      tryLogic: () async {
        final user = AuthController.get.userData!;
        await orderDS.deleteUserOrders(user);
      },
      secondsToCancel: Values.medlongOperationsSecondsToCancle,
    );
  }
}
