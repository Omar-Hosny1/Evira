import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/views/components/back-arrow.dart';
import 'package:evira/views/components/base/base-button.dart';
import 'package:evira/views/components/cart-container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Cart'),
          leading: BackArrow(),
        ),
        bottomNavigationBar: Container(
          height: 120,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(fontSize: 23),
                  ),
                  GetBuilder<CartController>(
                    id: Strings.cartGetBuilderId,
                    builder: (controller) => Text(
                      controller.cartAmount.toString(),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              BaseButton(
                onPressed: () {
                  Get.defaultDialog(
                      middleText: 'Your Order Has Been Saved Successfuly...',
                      radius: 10,
                      titlePadding: EdgeInsets.only(top: 20),
                      title: 'Thanks For Dealing With Evira',
                      custom: Icon(
                        Icons.done_all,
                        color: Colors.green,
                      ));
                },
                text: ('Checkout Now!'),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.horizontal_padding,
            vertical: Dimens.vertical_padding,
          ),
          child: FutureBuilder(
            future: CartController.get.getUserCart(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError == true) {
                return Center(child: Text(snapshot.error.toString()));
              }
              return const CartContainer();
            },
          ),
        ),
      ),
    );
  }
}
