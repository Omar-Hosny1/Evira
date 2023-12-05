import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/utils/constants/dimens.dart';
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
          padding: const EdgeInsets.only(
            left: Dimens.horizontal_padding,
            right: Dimens.horizontal_padding,
            bottom: Dimens.vertical_padding,
          ),
          child: Column(
            children: [
              Expanded(
                child: GetBuilder<CartController>(
                  builder: (controller) => FutureBuilder(
                    future: controller.getUserCart(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text('Wait');
                      }
                      if (snapshot.hasError == true) {
                        print(
                            '***************** Cart Data ERROR **********************');
                        return Text(snapshot.error.toString());
                      }
                      if (controller.cartProducts.isEmpty == true) {
                        return Text('Start Add Products To Your Cart Now');
                      }
                      print(
                          '************** controller.currentUserCart ****************');
                      print(controller.currentUserCart);
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.cartProducts.length,
                        itemBuilder: (context, index) =>
                            Text(controller.cartProducts[index].name),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
