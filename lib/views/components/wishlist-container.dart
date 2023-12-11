import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/views/components/wishlist-item.dart';
import 'package:flutter/material.dart';

class WishlistContainer extends StatelessWidget {
  const WishlistContainer({super.key, required this.wishlistProducts});

  final List<QueryDocumentSnapshot<Object?>> wishlistProducts;
  @override
  Widget build(BuildContext context) {
    if (wishlistProducts.isEmpty) {
      return Center(
        child: Text('Start Add Products To Your Wishlist Now'),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: wishlistProducts.length,
      itemBuilder: (context, index) => WishlistItem(
        Product.fromJson(
          wishlistProducts[index].data() as Map,
        ),
      ),
    );
  }
}
