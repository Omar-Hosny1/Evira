import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/views/components/cart-item.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CartContainer extends StatelessWidget {
  const CartContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      id: Strings.cartGetBuilderId,
      builder: (controller) => Column(
        children: [
          if (controller.cartProducts.isEmpty)
            Center(
              child: Text('Your Cart is Empty'),
            ),
          if (controller.cartProducts.isNotEmpty)
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.cartProducts.length,
                itemBuilder: (context, index) => CartItem(
                  product: Product.fromJson(
                    controller.cartProducts[index].data() as Map,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
