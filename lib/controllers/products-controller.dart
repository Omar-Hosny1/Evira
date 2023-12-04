import 'package:evira/controllers/auth-controller.dart';
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

  @override
  void onInit() async {
    super.onInit();
    _productRepository = ProductRepository(ProductDS());
    print('*************** GETTING THE PRODUCTS ***************');
    await WishlistController.get.getUserWishlistFromRepo();
    _listenAndGetProducts();
    // print('snackbar /////////////////////////');
    // Get.snackbar(fetchingState.name, fetchingState.name);
  }

  @override
  Future onReady() async {
    // time to open some resources
    print('****************** READY **************');
  }

  @override
  void onClose() {
    // time to close some resources and to do other cleanings
    print('****************** CLOSED **************');
  }

  List<Product> get products {
    return [..._prods];
  }

  Future<Product?> getProduct(int id) async {
    final product = await _productRepository.getProductById(id);
    return product;
  }

  List<Product> getWishlistProducts(Map<String, bool> ids) {
    final List<Product> wishlistProducts = [];
    for (var i = 0; i < _prods.length; i++) {
      if (ids[_prods[i].id.toString()] == true) {
        wishlistProducts.add(_prods[i]);
      }
    }
    return wishlistProducts;
  }

  void _listenAndGetProducts() {
    _productRepository.listenToProducts((data, fetchingState) {
      _prods = data ?? _prods;
      update([Strings.productsGetBuilderId]);
    });
  }

  bool _isUserWeightWithinTheProductWeightConstrains(
    String productPreferedWeight,
    int userWeight,
  ) {
    final weightConstrains = productPreferedWeight.split('-');
    if (weightConstrains[0] == 'over 90') {
      if (userWeight > 90) {
        return true;
      }
      return false;
    }
    print('**************** weightConstrains *****************');
    print(weightConstrains);
    final low = double.parse(weightConstrains[0]);
    final high = double.parse(weightConstrains[1]);
    print('*************** low *************');
    print(low);
    print('*************** high *************');
    print(high);
    if (userWeight >= low && userWeight <= high) {
      return true;
    }
    return false;
  }

  _isProductForYou(Product product) {
    try {
      final currentUserData = AuthController.get.userData!;
      return _isUserWeightWithinTheProductWeightConstrains(
            product.weight,
            currentUserData.getWeight!,
          ) ==
          true;
    } catch (e) {
      print('**************** _isProductForYou ERROR *******************');
      print(e);
      return false;
    }
  }

  void showForYouProducts() {
    _prods.removeWhere((element) => _isProductForYou(element) == false);
    print('******************* _prods.length *******************');
    print(_prods.length);
    update([Strings.productsGetBuilderId]);
  }

  void showAll() {
    _listenAndGetProducts();
  }
}
