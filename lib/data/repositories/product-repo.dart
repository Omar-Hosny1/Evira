import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/data/data-sources/product-ds.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/utils/helpers/error-handler.dart';

class ProductRepository {
  final ProductDS _productsDataSource;
  ProductRepository._(this._productsDataSource);

  static ProductRepository? _instance;

  static ProductRepository get instance {
    _instance ??= ProductRepository._(ProductDS());
    return _instance!;
  }

  Stream<QuerySnapshot<Object?>> listenToProducts() {
    return _productsDataSource.listenToProducts();
  }

  Future<Product?> getProductById(int id) async {
    final product =
        await _productsDataSource.getProductById(id) as Map<dynamic, dynamic>?;
    if (product == null) {
      return null;
    }
    return Product.fromJson(product);
  }

  Stream<QuerySnapshot<Object?>> getForYouProducts() {
    final currentUser = AuthController.get.userData!;

    final dataStream = _productsDataSource.getForYouProducts(
      currentUser.getGender!,
      currentUser.getWeight!,
    );
    // dataStream.
    return dataStream;
  }

  Future<QuerySnapshot<Object?>> getWishlistProducts(List<int> ids) async {
    return errorHandler(tryLogic: () async {
      return await _productsDataSource.getWishlistProducts(ids);
    });
  }

  Future<QuerySnapshot<Object?>> getCartProducts(List<int> ids) async {
    return errorHandler(tryLogic: () async {
      return await _productsDataSource.getCartProducts(ids);
    });
  }
}
