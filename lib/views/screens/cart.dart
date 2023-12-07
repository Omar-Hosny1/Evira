import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/views/components/cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.horizontal_padding,
            vertical: Dimens.vertical_padding,
          ),
          child: GetBuilder<CartController>(
            builder: (controller) => FutureBuilder(
              future: controller.getUserCart(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError == true) {
                  print(
                      '***************** Cart Data ERROR **********************');
                  return Center(child: Text(snapshot.error.toString()));
                }
                print(
                    '************** controller.currentUserCart ****************');
                print(controller.currentUserCart);
                return CartContainer(
                  products: controller.cartProducts,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
