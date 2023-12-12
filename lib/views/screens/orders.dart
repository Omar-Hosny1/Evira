import 'package:evira/controllers/order-controller.dart';
import 'package:evira/data/models/firebase-models/order.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/views/components/back-arrow.dart';
import 'package:evira/views/components/order-item.dart';
import 'package:flutter/material.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackArrow(),
          title: Text('Your Orders'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: Dimens.horizontal_padding,
            right: Dimens.horizontal_padding,
            bottom: Dimens.vertical_padding,
          ),
          child: FutureBuilder(
            future: OrderController.get.getUserOrders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError == true) {
                return Center(child: Text(snapshot.error.toString()));
              }
              final userOrders = snapshot.data;
              if (userOrders == null) {
                return const Center(
                    child: Text(
                  'No Orders, Order Some Products Now...',
                  textAlign: TextAlign.center,
                ));
              }
              final orders = userOrders.orders.values.toList();
              return ListView.builder(
                itemBuilder: (context, index) {
                  return OrderItem(
                    order: orders[index],
                  );
                },
                itemCount: orders.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
