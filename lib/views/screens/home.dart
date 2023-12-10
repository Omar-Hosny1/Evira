import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/controllers/products-controller.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/utils/constants/dimens.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/views/components/logo.dart';
import 'package:evira/views/components/main-drawer.dart';
import 'package:evira/views/components/product.dart';
import 'package:evira/views/components/toggle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(
          centerTitle: true,
          titleTextStyle:
              const TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
          title: const Logo(),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: Dimens.horizontal_padding,
            right: Dimens.horizontal_padding,
            bottom: Dimens.vertical_padding,
          ),
          child: Column(
            children: [
              Toggle(),
              Expanded(
                child: GetBuilder<ProductController>(
                  id: Strings.productsGetBuilderId,
                  builder: (controller) => StreamBuilder<QuerySnapshot>(
                    stream: controller.getCurrentProducts(),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (controller.isCartAndWishlistDataFetched == false) {
                        controller.fetchCartAndWishlistData();
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          controller.updateTheUI();
                        },
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 10,
                            childAspectRatio: 4 / 7,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => ProductView(
                            product: Product.fromJson(
                              snapshot.data!.docs[index].data() as Map,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
