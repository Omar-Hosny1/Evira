import 'package:evira/data/data-sources/product-ds.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/utils/types/data-callback.dart';

class ProductRepository {
  final ProductDS _productsDataSource;
  ProductRepository(this._productsDataSource);

  void listenToProducts(DataCallback<List<Product>?> cb) {
    _productsDataSource.listenToProducts((data) {
      cb(data.map((e) {
        return Product.fromJson(e as Map<dynamic, dynamic>);
      }).toList());
    });
  }

  Future<Product?> getProductById(int id) async {
    final product =
        await _productsDataSource.getProductById(id) as Map<String, dynamic>?;
    if (product == null) {
      return null;
    }
    return Product.fromJson(product);
  }
}
