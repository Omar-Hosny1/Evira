import 'package:evira/data/models/product.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductWishlistButton extends StatelessWidget {
  const ProductWishlistButton({
    super.key,
    required this.product,
  });

  final Product product;

  void _wishlistIconHandler() async {
    if (product.isAddedToWishlist.isTrue == true) {
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
    Widget buildIcon() {
      if (product.isLoadingStateForWishlist.isTrue == true) {
        return CircularProgressIndicator();
      }

      return Icon(
        product.isAddedToWishlist.isTrue == true
            ? Icons.favorite_rounded
            : Icons.favorite_outline_outlined,
        size: 30,
      );
    }

    return Obx(
      () => IconButton(
        onPressed: product.isLoadingStateForWishlist.isTrue
            ? null
            : () => _wishlistIconHandler(),
        icon: buildIcon(),
      ),
    );
  }
}
