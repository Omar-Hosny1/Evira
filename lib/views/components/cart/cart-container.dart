import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/data/models/orderd-product.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/views/components/cart/cart-item.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CartContainer extends StatelessWidget {
  const CartContainer({super.key});

  @override
  Widget build(BuildContext context) {

    Widget buildCart(CartController controller) {
      print('0000000000000000000 controller.cartProducts.length');
      print(controller.cartProducts.length);
      if (controller.cartProducts.isEmpty) {
        return const Center(
          child: Text('Your Cart is Empty'),
        );
      }
      return ListView.builder(
        shrinkWrap: true,
        itemCount: controller.cartProducts.length,
        itemBuilder: (context, index) {
          final currentProductData = controller.cartProducts[index].data();
          final OrderedProduct product = OrderedProduct.fromJson(
            currentProductData as Map,
            quantity: CartController.get.getProductQuantity(
              currentProductData['id'].toString(),
            ),
          );
          return CartItem(
            key: ValueKey(product.id),
            product: product,
          );
        },
      );
    }

    return GetBuilder<CartController>(
      id: Strings.cartGetBuilderId,
      builder: (controller) => buildCart(controller),
    );
  }
}
