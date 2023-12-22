import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/views/components/orders/order-btn.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartBottomBar extends StatelessWidget {
  CartBottomBar({super.key});
  final Rx<bool> _isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          OrderBtn(isLoading: _isLoading),
        ],
      ),
    );
  }
}
