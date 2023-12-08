import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/utils/constants/strings.dart';

class ProductDS {
  ProductDS._privateConstructor();
  static final ProductDS _dataSource = ProductDS._privateConstructor();
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection(Strings.productsCollectionName);

  factory ProductDS() {
    return _dataSource;
  }

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
    print(' ***************** getForYouProducts **************');
    print(gender);
    return _productsCollection
        .where('gender', isEqualTo: gender)
        .get()
        .asStream();
  }

  // raiseProduct() async {
  //   print(da[6.toString()]);
  //   da.forEach((key, value) async {
  //     await _productsCollection.add(value);
  //   });
  //   // ignore: unused_local_variable
  //   // for (var i = 1; i < 104; i++) {
  //   //   print(i);
  //   //   print(da[i.toString()]);
  //   // }
  // }

  Future<QuerySnapshot<Object?>> getWishlistProducts(List ids) async {
    print('************* ids ***************');
    print(ids);
    final data = await _productsCollection.where('id', whereIn: ids.map((e) => int.parse(e))).get();
    print('************* getWishlistProducts ****************');
    print(data.docs.length);
    return data;
  }
}
