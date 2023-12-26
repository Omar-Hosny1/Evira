import 'package:evira/data/models/firebase-models/user-orders.dart';
import 'package:evira/data/models/orderd-product.dart';
import 'package:evira/data/repositories/order-repo.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  late final OrderRepo _orderRepo;
  static OrderController get get => Get.find();

  @override
  void onInit() {
    super.onInit();
    _orderRepo = OrderRepo.instance;
  }

  Future<void> addOrder(
      List<OrderedProduct> products, double totalAmount) async {
    try {
      await _orderRepo.addOrderFromRepo(products, totalAmount);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserOrders?> getUserOrders() async {
    try {
      return await _orderRepo.getUserOrdersFromRepo();
    } catch (e) {
      rethrow;
    }
  }
}
