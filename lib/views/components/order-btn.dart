import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:evira/utils/helpers/snack-bar.dart';
import 'package:evira/views/components/base/base-button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderBtn extends StatelessWidget {
  const OrderBtn({super.key, required this.isLoading});
  final Rx<bool> isLoading;
  
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BaseButton(
        onPressed: isLoading.isTrue
            ? null
            : () async {
                errorHandlerInView(tryLogic: () async {
                  if (CartController.get.cartProducts.length == 0) {
                    showSnackbar(
                      SnackbarState.danger,
                      'Try Add Some Product To Your Cart!',
                      'Your Cart is Empty!',
                    );
                    return;
                  }
                  isLoading.value = true;
                  await CartController.get.makeOrder();
                  Get.defaultDialog(
                      middleText: 'Your Order Has Been Saved Successfuly...',
                      radius: 10,
                      titlePadding: EdgeInsets.only(top: 20),
                      title: 'Thanks For Dealing With Evira',
                      custom: const Icon(
                        Icons.done_all,
                        color: Colors.green,
                      ));
                }, finallyLogic: () {
                  isLoading.value = false;
                });
              },
        text: isLoading.isTrue ? 'Loading...' : 'Checkout Now!',
      ),
    );
  }
}
