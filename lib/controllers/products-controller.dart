import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/controllers/cart-controller.dart';
import 'package:evira/controllers/wishlist-controller.dart';
import 'package:evira/data/data-sources/product-ds.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/data/repositories/product-repo.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  late final ProductRepository _productRepository;
  List<Product> _prods = [];
  static ProductController get get => Get.find();
  bool _isDiscoverProductsSelected = true;

  get isDiscoverProductsSelected {
    return _isDiscoverProductsSelected;
  }

  @override
  void onInit() async {
    super.onInit();
    _productRepository = ProductRepository(ProductDS());
  }

  @override
  void onClose() {
    // time to close some resources and to do other cleanings
    print('****************** CLOSED **************');
    _prods = [];
  }

  List<Product> get products {
    return [..._prods];
  }

  Future<Product?> getProduct(int id) async {
    final product = await _productRepository.getProductById(id);
    return product;
  }

  Future<QuerySnapshot<Object?>> getWishlistProducts(
    List<int> ids,
  ) async {
    try {
      return await _productRepository.getWishlistProducts(ids);
    } catch (e) {
      rethrow;
    }
  }

  Future<QuerySnapshot<Object?>> getCartProducts(List<int> ids) async {
    try {
      return await _productRepository.getCartProducts(ids);
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Object?>> getCurrentProducts() {
    print('Stream<QuerySnapshot<Object?>> getCurrentProducts Called');
    if (_isDiscoverProductsSelected == true) {
      return _listenAndGetAllProducts();
    }
    return _listenAndGetForYouProducts();
  }

  Stream<QuerySnapshot<Object?>> _listenAndGetAllProducts() {
    return _productRepository.listenToProducts();
  }

  Stream<QuerySnapshot<Object?>> _listenAndGetForYouProducts() {
    return _productRepository.getForYouProducts();
  }

  bool isUserWeightWithinTheProductWeightConstrains(
    int minWeight,
    int maxWeight,
  ) {
    int userWeight = AuthController.get.userData!.getWeight!;
    if (userWeight >= minWeight && userWeight <= maxWeight) {
      return true;
    }
    return false;
  }

  List<Product> filterForYouProducts(
    List<QueryDocumentSnapshot<Object?>> products,
  ) {
    final List<Product> filteredProducts = [];
    for (var i = 0; i < products.length; i++) {
      final product = Product.fromJson(products[i].data() as Map);
      if (isUserWeightWithinTheProductWeightConstrains(
              product.minWeight, product.maxWeight) ==
          true) {
        filteredProducts.add(product);
      }
    }
    return filteredProducts;
  }

  void showForYouProducts() {
    print('showForYouProducts CALLED');
    _isDiscoverProductsSelected = false;
    update([Strings.productsGetBuilderId]);
  }

  void updateTheUI() {
    print('***************** updateTheUI RAN ********************');
    update([Strings.productsGetBuilderId]);
  }

  void showAll() {
    _isDiscoverProductsSelected = true;
    update([Strings.productsGetBuilderId]);
  }

  Future<void> fetchCartAndWishlistData() async {
    await CartController.get.getUserCart();
    await WishlistController.get.getUserWishlist();
  }
}
