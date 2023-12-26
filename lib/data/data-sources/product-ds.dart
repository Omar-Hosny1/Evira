import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/utils/constants/strings.dart';
import './data.dart';

class ProductDS {
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection(Strings.productsCollectionName);
  Stream<QuerySnapshot<Object?>> listenToProducts() {
    return _productsCollection.snapshots();
  }

  Future<Object?> getProductById(int id) async {
    final QuerySnapshot<Object?> product =
        await _productsCollection.where('id', isEqualTo: id).get();
    if (product.docs.isNotEmpty) {
      return product.docs[0].data();
    }
    return null;
  }

  Stream<QuerySnapshot<Object?>> getForYouProducts(String gender, int weight) {
    return _productsCollection
        .where('gender', isEqualTo: gender)
        .get()
        .asStream();
  }

  raiseProduct() async {
    da.forEach((key, value) async {
      await _productsCollection.add(value);
    });
  }

  Future<QuerySnapshot<Object?>> getWishlistProducts(List<int> ids) async {
    final data = await _productsCollection.where('id', whereIn: ids).get();
    return data;
  }

  Future<QuerySnapshot<Object?>> getCartProducts(List<int> ids) async {
    final data = await _productsCollection.where('id', whereIn: ids).get();
    return data;
  }
}
