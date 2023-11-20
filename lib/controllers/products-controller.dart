import 'package:evira/data/data-sources/product-ds.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/data/repositories/product-repo.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  late final ProductRepository _productRepository;
  List<Product> _prods = [];

  @override
  void onInit() {
     _productRepository = ProductRepository(ProductDS());
    _listenAndGetProducts();
    super.onInit();
  }

  List<Product> get products {
    return [..._prods];
  }

  Future<Product?> getProduct(int id) async {
    final product = await _productRepository.getProductById(id);
    return product;
  }

  void _listenAndGetProducts() {
    _productRepository.listenToProducts((data) {
      _prods = data ?? [];
      update([Strings.productsGetBuilderId]);
    });
  }
}
