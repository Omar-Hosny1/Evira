import 'package:evira/data/models/orderd-product.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/views/components/common/back-arrow.dart';
import 'package:evira/views/components/orders/ordered-produt-item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderedProducts extends StatelessWidget {
  const OrderedProducts({super.key});
  static const routeName = '/ordered-products';

  @override
  Widget build(BuildContext context) {
    final List<OrderedProduct> products = Get.arguments;
    print(products.length);
    print(products.length);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackArrow(),
          title: Text('Ordered Products'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: Dimens.horizontal_padding,
            right: Dimens.horizontal_padding,
            bottom: Dimens.vertical_padding,
          ),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return OrderedProductItem(
                product: products[index],
                key: ValueKey(
                  products[index].id,
                ),
              );
            },
            itemCount: products.length,
          ),
        ),
      ),
    );
  }
}
