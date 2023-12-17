import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/controllers/products-controller.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/views/components/product.dart';
import 'package:flutter/material.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    super.key,
    required this.products,
    required this.controller,
  });
  final List<QueryDocumentSnapshot<Object?>> products;
  final ProductController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isDiscoverProductsSelected) {
      return RefreshIndicator(
        onRefresh: () async {
          controller.updateTheUI();
        },
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 10,
            childAspectRatio: 4 / 7,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = Product.fromJson(
              products[index].data() as Map,
            );
            return ProductView(
              key: ValueKey(product.id),
              product: product,
            );
          },
        ),
      );
    }
    final filteredProducts = controller.filterForYouProducts(products);
    if (filteredProducts.isEmpty) {
      return Center(
        child: Text('No Recommended Products'),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        controller.updateTheUI();
      },
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 10,
          childAspectRatio: 4 / 7,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          return ProductView(
            key: ValueKey(filteredProducts[index].id),
            product: filteredProducts[index],
          );
        },
      ),
    );
  }
}
