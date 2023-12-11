import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistItem extends StatelessWidget {
  final Product product;
  final RxBool _isLoading = false.obs;

  WishlistItem(this.product, {super.key});

  void removeFromWishlistHandler() async {
    await errorHandlerInView(tryLogic: () async {
      _isLoading.value = true;
      await product.removeFromWishlist();
    }, finallyLogic: () {
      _isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(product.name),
        subtitle: Text(product.gender),
        leading: CachedNetworkImage(
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
        trailing: Obx(
          () => InkWell(
            onTap: _isLoading.isTrue ? null : removeFromWishlistHandler,
            child: _isLoading.isTrue
                ? CircularProgressIndicator()
                : Icon(
                    Icons.remove,
                    color: Colors.red,
                  ),
          ),
        ),
      ),
    );
  }
}
