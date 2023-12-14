import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/data/models/firebase-models/order.dart';
import 'package:evira/data/models/orderd-product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  final Order order;

  OrderItem({required this.order});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(order.date);
    String formattedDate = DateFormat.yMMMMd().add_jms().format(dateTime);
    final sectionTextStyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 18);
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Date:',
              style: sectionTextStyle,
            ),
            SizedBox(height: 4.0),
            Text(formattedDate),
            SizedBox(height: 8.0),
            Text(
              'Total Price:',
              style: sectionTextStyle,
            ),
            SizedBox(height: 4.0),
            Text('${order.totalPrice.toStringAsFixed(2)} EGP'),
            SizedBox(height: 8.0),
            Text(
              'Ordered Products:',
              style: sectionTextStyle,
            ),
            SizedBox(height: 4.0),
            SizedBox(
              height: order.products.length == 1 ? 70 : 110,
              child: ListView.builder(
                itemCount: order.products.length,
                itemBuilder: (context, index) {
                  return OrderedProductItem(product: order.products[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderedProductItem extends StatelessWidget {
  final OrderedProduct product;

  OrderedProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(2),
      title: Text(product.name),
      leading: CachedNetworkImage(
        imageUrl: product.imageUrl,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      subtitle: Text('Quantity: ${product.quantity}'),
      trailing: Text('${product.price.toStringAsFixed(2)} EGP'),
    );
  }
}
