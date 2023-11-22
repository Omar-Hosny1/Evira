import 'dart:async';

import 'package:evira/utils/types/data-callback.dart';
import 'package:evira/utils/types/fetching-state-callback.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductDS {
  ProductDS._privateConstructor();
  static final ProductDS _dataSource = ProductDS._privateConstructor();

  FirebaseDatabase database = FirebaseDatabase.instance;
  final StreamController<List<Object?>?> _dataController =
      StreamController<List<Object?>?>();
  Stream<List<Object?>?> get onData => _dataController.stream;

  factory ProductDS() {
    return _dataSource;
  }

  void listenToProducts(
    DataCallback<List<Object?>?> onData,
  ) {
    onData(null, FetchingState.waiting);
    final DatabaseReference reference = database.ref('products');
    reference.onValue.listen((event) {
      if (event.snapshot.value == null) {
        onData(null, FetchingState.faliure);
      }
      final data = event.snapshot.value as List<Object?>;
      onData(data, FetchingState.done);
    });
  }

  Future<Object?> getProductById(int id) async {
    final DatabaseReference reference = database.ref('products/${id - 1}');
    final productSnapShot = await reference.get();
    if (productSnapShot.exists) {
      return productSnapShot.value;
    }
    return null;
  }
}
