import 'package:evira/controllers/wishlist-controller.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/views/components/back-arrow.dart';
import 'package:evira/views/components/wishlist-item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Wishlist extends StatelessWidget {
  const Wishlist({super.key});
  static const routeName = '/wishlist';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackArrow(),
          title: Text('Wishlist Products'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: Dimens.horizontal_padding,
            right: Dimens.horizontal_padding,
            bottom: Dimens.vertical_padding,
          ),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder(
                future: WishlistController.get.getUserWishlist(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError == true) {
                    print(
                        '***************** Wishlist Data ERROR **********************');
                    return Text(snapshot.error.toString());
                  }
                  if (WishlistController.get.wishlistProducts.isEmpty) {
                    return Text('Start Add Products To Your Wishlist Now');
                  }
                  print(
                      '************** controller.wishlistProducts ****************');
                  print(WishlistController.get.wishlistProducts);
                  print(WishlistController.get.wishlistProducts[0].data());
                  return GetBuilder<WishlistController>(
                    id: Strings.wishlistGetBuilderId,
                    builder: (controller) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.wishlistProducts.length,
                      itemBuilder: (context, index) => WishlistItem(
                        Product.fromJson(
                          controller.wishlistProducts[index].data() as Map,
                        ),
                      ),
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
