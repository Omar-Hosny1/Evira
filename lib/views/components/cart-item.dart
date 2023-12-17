import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/data/models/orderd-product.dart';
import 'package:evira/utils/helpers/error-handler-view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItem extends StatelessWidget {
  final OrderedProduct product;

  const CartItem({
    super.key,
    required this.product,
  });

  void handleAddToCart(RxInt productQuantity) async {
    await errorHandlerInView(tryLogic: () async {
      await product.addToCart();
      productQuantity.value = product.getProductQuantity();
    });
  }

  void handleRemoveFromCart(RxInt productQuantity) async {
    await errorHandlerInView(tryLogic: () async {
      await product.removeFromCart();
      productQuantity.value = product.getProductQuantity();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget buildProductQuantity() {
      if (product.isLoadingStateForCart.isTrue) {
        return const FittedBox(child: CircularProgressIndicator());
      }
      return Text(
        product.quantity.toString(),
        textAlign: TextAlign.center,
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: product.imageUrl,
                height: 60,
                width: 60,
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 145,
                    child: Text(
                      product.formatProductName(),
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(product.formatProductPrice()),
                ],
              ),
            ],
          ),
          Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: product.isLoadingStateForCart.isTrue ||
                          CartController.get.isAbleToAddOrRemove.isFalse
                      ? null
                      : () => handleRemoveFromCart(product.quantity.obs),
                ),
                SizedBox(width: 15, child: buildProductQuantity()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: product.isLoadingStateForCart.isTrue ||
                          CartController.get.isAbleToAddOrRemove.isFalse
                      ? null
                      : () => handleAddToCart(product.quantity.obs),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Container(
    //   height: 80,
    //   margin: const EdgeInsets.symmetric(vertical: 6),
    //   child: Center(
    //     child: Card(
    //       child: ListTile(
    //         title: Text(product.name),
    //         subtitle: Text(product.formatProductPrice()),
    //         leading: CachedNetworkImage(imageUrl: product.imageUrl),
    //         trailing: Row(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Obx(
    //               () => IconButton(
    //                 icon: Icon(Icons.remove),
    //                 onPressed: product.isLoadingStateForCart.isTrue
    //                     ? null
    //                     : () => handleRemoveFromCart(product.quantity.obs),
    //               ),
    //             ),
    //             SizedBox(width: 20, child: Obx(() => buildProductQuantity())),
    //             Obx(
    //               () => IconButton(
    //                 icon: Icon(Icons.add),
    //                 onPressed: product.isLoadingStateForCart.isTrue
    //                     ? null
    //                     : () => handleAddToCart(product.quantity.obs),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
