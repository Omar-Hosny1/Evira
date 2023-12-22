import 'package:evira/data/models/product.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistBtnHandler extends StatelessWidget {
  const WishlistBtnHandler({
    super.key,
    required this.product,
  });

  final Product product;
  void _wishlistIconHandler() async {
    if (product.isAddedToWishlist.value == true) {
      await errorHandlerInView(tryLogic: () async {
        await product.removeFromWishlist();
      });
      return;
    }
    await errorHandlerInView(tryLogic: () async {
      await product.addToWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: product.isAddedToWishlist.value == true
                ? Colors.transparent
                : Colors.black,
            elevation: 0.0,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
              side: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
          onPressed: product.isLoadingStateForWishlist.value
              ? null
              : _wishlistIconHandler,
          child: Text(
            product.isLoadingStateForWishlist.value == true
                ? 'Loading...'
                : product.isAddedToWishlist.value == true
                    ? 'Remove From Wishlist'
                    : 'Add To Wishlist',
            style: TextStyle(
              color: product.isAddedToWishlist.value == true
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
