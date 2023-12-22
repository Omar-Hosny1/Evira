import 'package:evira/data/models/product.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartBtnHandler extends StatelessWidget {
  const CartBtnHandler({
    super.key,
    required this.product,
  });

  final Product product;

  void _cartButtonHandler() async {
    if (product.isAddedToCart.isTrue == true) {
      await errorHandlerInView(tryLogic: () async {
        await product.removeFromCartPermanently();
      });
      return;
    }
    await errorHandlerInView(tryLogic: () async {
      await product.addToCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: product.isAddedToCart.value == true
                ? Colors.transparent
                : Colors.black,
            elevation: 0.0,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: const BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          onPressed:
              product.isLoadingStateForCart.value ? null : _cartButtonHandler,
          child: Text(
            product.isLoadingStateForCart.value
                ? 'Loading...'
                : product.isAddedToCart.value == true
                    ? 'Remove From Cart'
                    : 'Add To Cart',
            style: TextStyle(
              color: product.isAddedToCart.value == true
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      );
    });
  }
}
