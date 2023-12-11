import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/controllers/products-controller.dart';
import 'package:evira/controllers/wishlist-controller.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/views/components/base/base-button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool? _isFavouriteHelper(String productId) {
  final currentUserWishlist = WishlistController.get.currentUserWishlist;
  if (currentUserWishlist == null) {
    return null;
  }
  return currentUserWishlist.wishlist[productId] == true;
}

bool? isAddedToCartHelper(String productId) {
  final currentUserCart = CartController.get.currentUserCart;
  if (currentUserCart == null) {
    return null;
  }
  return currentUserCart.cart[productId] != null;
}

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
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('Name'), Text(product.name)],
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
                        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
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
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 0.0,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Add To Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 0.0,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Add To Wishlist',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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
