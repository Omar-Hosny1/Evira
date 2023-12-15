import 'package:evira/data/models/firebase-models/order.dart';
import 'package:evira/views/screens/orders/ordered-products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  final Order order;

  const OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(order.date);
    String formattedDate = DateFormat.yMMMMd().add_jms().format(dateTime);
    const sectionTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
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
            Container(
              color: Theme.of(context).colorScheme.background,
              child: ListTile(
                onTap: (){
                  Get.toNamed(OrderedProducts.routeName, arguments: order.products);
                },
                title: Text('Show Ordered Products'),
                trailing: Icon(
                  Icons.arrow_forward,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
