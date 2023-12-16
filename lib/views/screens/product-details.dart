import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/controllers/products-controller.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});
  static final routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as int;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: Dimens.vertical_padding,
            horizontal: Dimens.horizontal_padding,
          ),
          child: Column(
            children: [
              FutureBuilder(
                future: ProductController.get.getProduct(id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  final product = snapshot.data;
                  if (product == null) {
                    return Center(child: const Text('No Product Found'));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 300,
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('Name'), Text(product.name)],
                          ),
                        ),
                      ),
                      Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Price'),
                              Text(product.formatProductPrice())
                            ],
                          ),
                        ),
                      ),
                      Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Weight'),
                              Text(product.formatProductWeight())
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(
                          () => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  product.isAddedToCart.isTrue == true
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
                            onPressed: product.isLoadingStateForCart.isTrue
                                ? null
                                : () async {
                                    if (product.isAddedToCart.isTrue == true) {
                                      await errorHandlerInView(
                                          tryLogic: () async {
                                        await product
                                            .removeFromCartPermanently();
                                      });
                                      return;
                                    }
                                    await errorHandlerInView(
                                        tryLogic: () async {
                                      await product.addToCart();
                                    });
                                  },
                            child: Text(
                              product.isLoadingStateForCart.isTrue
                                  ? 'Loading...'
                                  : product.isAddedToCart.value == true
                                      ? 'Remove From Cart'
                                      : 'Add To Cart',
                              style: TextStyle(
                                color: product.isAddedToCart.isTrue == true
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // WISHLIST BTN
                      SizedBox(
                        width: double.infinity,
                        child: Obx(() {
                          print('Obx REBUILT');
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  product.isAddedToWishlist.isTrue == true
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
                            onPressed: product.isLoadingStateForWishlist.isTrue
                                ? null
                                : () async {
                                    if (product.isAddedToWishlist.isTrue ==
                                        true) {
                                      await errorHandlerInView(
                                          tryLogic: () async {
                                        await product.removeFromWishlist();
                                      });
                                      return;
                                    }

                                    await errorHandlerInView(
                                        tryLogic: () async {
                                      await product.addToWishlist();
                                    });
                                  },
                            child: Text(
                              product.isLoadingStateForWishlist.isTrue == true
                                  ? 'Loading...'
                                  : product.isAddedToWishlist.isTrue == true
                                      ? 'Remove From Wishlist'
                                      : 'Add To Wishlist',
                              style: TextStyle(
                                color: product.isAddedToWishlist.isTrue == true
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
