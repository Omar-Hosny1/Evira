import 'package:evira/utils/types/data-callback.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductDS {
  ProductDS._privateConstructor();
  static final ProductDS _dataSource = ProductDS._privateConstructor();

  FirebaseDatabase database = FirebaseDatabase.instance;

  factory ProductDS() {
    return _dataSource;
  }

  void listenToProducts(DataCallback<List<Object?>> onData) async {
    final DatabaseReference reference = database.ref('products');
    reference.onValue.listen((event) {
      final data = event.snapshot.value as List<Object?>;
      onData(data);
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
