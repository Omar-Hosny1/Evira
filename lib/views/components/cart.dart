import 'package:evira/data/models/product.dart';
import 'package:evira/views/components/cart-item.dart';
import 'package:flutter/widgets.dart';

class CartContainer extends StatelessWidget {
  const CartContainer({super.key, required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (products.isEmpty)
          Center(
            child: Text('Your Cart is Empty'),
          ),
        if (products.isNotEmpty)
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) => CartItem(
                product: products[index],
              ),
            ),
          ),
      ],
    );
  }
}
