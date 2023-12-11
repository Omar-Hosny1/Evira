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
  bool _isCartAndWishlistDataFetched = false;

  bool get isCartAndWishlistDataFetched => _isCartAndWishlistDataFetched;

  @override
  void onInit() async {
    super.onInit();
    _productRepository = ProductRepository(ProductDS());
    print('*************** GETTING THE PRODUCTS ***************');

    print('.................. FINISHED ..................');
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

  bool _isProductGenderTheSameAsUserGender(
    String productGender,
    String userGender,
  ) {
    if (productGender == userGender) {
      return true;
    }
    return false;
  }

  bool _isProductForYou(Product product) {
    try {
      final currentUserData = AuthController.get.userData!;
      final isUserWeightWithinTheProductWeightConstrains =
          _isUserWeightWithinTheProductWeightConstrains(
        product.weight,
        currentUserData.getWeight!,
      );
      final isProductGenderTheSameAsUserGender =
          _isProductGenderTheSameAsUserGender(
        product.gender,
        currentUserData.getGender!,
      );
      if (isUserWeightWithinTheProductWeightConstrains &&
          isProductGenderTheSameAsUserGender) {
        return true;
      }
      return false;
    } catch (e) {
      print('**************** _isProductForYou ERROR *******************');
      print(e);
      return false;
    }
  }

  void showForYouProducts() {
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
    try {
      await CartController.get.getUserCart();
      await WishlistController.get.getUserWishlist();
      _isCartAndWishlistDataFetched = true;
      updateTheUI();
    } catch (e) {
      updateTheUI();
      rethrow;
    }
  }
}
