import 'package:cached_network_image/cached_network_image.dart';
import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/data/models/user.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/views/components/back-arrow.dart';
import 'package:evira/views/screens/cart.dart';
import 'package:evira/views/screens/orders.dart';
import 'package:evira/views/screens/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    final User currentUser = AuthController.get.userData!;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackArrow(),
          title: Text('Your Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: Dimens.horizontal_padding,
            right: Dimens.horizontal_padding,
            top: Dimens.vertical_padding,
            bottom: Dimens.vertical_padding,
          ),
          child: Column(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: CachedNetworkImageProvider(
                            currentUser.getImagePath!,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser.getName!,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              currentUser.getEmail!,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Card(
                      child: ListTile(
                        trailing: Text(currentUser.getAge!.toString()),
                        leading: Icon(Icons.person),
                        title: Text('Your Age'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        trailing: Text(currentUser.getHeight!.toString()),
                        leading: Icon(Icons.height),
                        title: Text('Your Height'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        trailing: Text(currentUser.getWeight!.toString()),
                        leading: Icon(Icons.monitor_weight),
                        title: Text('Your Weight'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () {
                          Get.toNamed(Wishlist.routeName);
                        },
                        trailing: Icon(Icons.arrow_forward),
                        leading: Icon(Icons.favorite),
                        title: Text('Your Wishlist'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () {
                          Get.toNamed(Cart.routeName);
                        },
                        trailing: Icon(Icons.arrow_forward),
                        leading: Icon(Icons.shopping_bag),
                        title: Text('Your Cart'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () {
                          Get.toNamed(Orders.routeName);
                        },
                        trailing: Icon(Icons.arrow_forward),
                        leading: Icon(Icons.payments),
                        title: Text('Your Orders'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        onTap: () async {
                          Get.defaultDialog(
                            titlePadding: EdgeInsets.only(top: 20),
                            title: 'Logout Confirmation',
                            middleText: 'Are You Sure That You Want To Logout?',
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await AuthController.get.logOut();
                                },
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Colors.red,
                        ),
                        leading: Icon(
                          Icons.logout,
                          color: Colors.red,
                        ),
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
