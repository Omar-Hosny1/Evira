import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistItem extends StatelessWidget {
  final Product product;

  const WishlistItem(this.product, {super.key});

  void removeFromWishlistHandler() async {
    await errorHandlerInView(tryLogic: () async {
      await product.removeFromWishlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 10, bottom: 15, top: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CachedNetworkImage(
                height: 70,
                width: 70,
                imageUrl: product.imageUrl,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Text(product.name)
            ],
          ),
          Obx(
            () => InkWell(
              onTap: product.isLoadingStateForWishlist.isTrue
                  ? null
                  : removeFromWishlistHandler,
              child: product.isLoadingStateForWishlist.isTrue
                  ? CircularProgressIndicator()
                  : Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
