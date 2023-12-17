import 'package:evira/data/models/product.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:evira/views/components/base/base-button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductCartButton extends StatelessWidget {
  const ProductCartButton({
    super.key,
    required this.product,
  });

  final Product product;

  void cartButtonHandler() async {
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
    return BaseButton(
      buttonStyle: ElevatedButton.styleFrom(
        elevation: 0.0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 5),
        backgroundColor: product.isAddedToCart.isTrue == true
            ? Colors.transparent
            : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
      textStyle: TextStyle(
        color:
            product.isAddedToCart.isTrue == true ? Colors.black : Colors.white,
      ),
      text: product.isLoadingStateForCart.isTrue == true
          ? 'Loading...'
          : product.isAddedToCart.isTrue == true
              ? 'Remove Cart'
              : 'Add To Cart',
      onPressed: product.isLoadingStateForCart.isTrue
          ? null
          : () => cartButtonHandler(),
    );
  }
}
