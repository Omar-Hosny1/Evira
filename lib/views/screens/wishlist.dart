import 'package:evira/controllers/wishlist-controller.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/utils/helpers/error-handler.dart';
import 'package:evira/views/components/main-drawer.dart';
import 'package:evira/views/components/wishlist-container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Wishlist extends StatelessWidget {
  const Wishlist({super.key});
  static const routeName = '/wishlist';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
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
                    return Center(
                        child: Text(
                      formatErrorMessage(
                        snapshot.error.toString(),
                      ),
                    ));
                  }
                  return GetBuilder<WishlistController>(
                    id: Strings.wishlistGetBuilderId,
                    builder: (controller) => WishlistContainer(
                      wishlistProducts: controller.wishlistProducts,
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
