import 'package:evira/data/models/product.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:evira/views/components/base/base-button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCartButton extends StatelessWidget {
  const ProductCartButton({
    super.key,
    required this.isAddedToCart,
    required this.isLoadingStateForCart,
    required this.product,
  });

  final Rx<bool?> isAddedToCart;
  final RxBool isLoadingStateForCart;
  final Product product;

  void cartButtonHandler(Rx<bool?> isAddedToCart) async {
    if (isAddedToCart.isTrue == true) {
      await errorHandlerInView(tryLogic: () async {
        isLoadingStateForCart.value = true;
        await product.removeFromCartPermanently();
        isAddedToCart.value = false;
      }, finallyLogic: () {
        isLoadingStateForCart.value = false;
      });
      return;
    }
    await errorHandlerInView(tryLogic: () async {
      isLoadingStateForCart.value = true;
      await product.addToCart();
      isAddedToCart.value = true;
    }, finallyLogic: () {
      isLoadingStateForCart.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BaseButton(
        buttonStyle: ElevatedButton.styleFrom(
          elevation: 0.0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 5),
          backgroundColor:
              isAddedToCart.isTrue == true ? Colors.transparent : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
        textStyle: TextStyle(
          color: isAddedToCart.isTrue == true ? Colors.black : Colors.white,
        ),
        text: isLoadingStateForCart.isTrue == true
            ? 'Loading...'
            : isAddedToCart.isTrue == true
                ? 'Remove Cart'
                : 'Add To Cart',
        onPressed: isLoadingStateForCart.isTrue
            ? null
            : () => cartButtonHandler(isAddedToCart),
      ),
    );
  }
}
