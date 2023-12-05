import 'package:evira/controllers/products-controller.dart';
import 'package:evira/data/data-sources/wishlist-ds.dart';
import 'package:evira/data/models/firebase-models/user-wishlist.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/data/repositories/wishlist-repo.dart';
import 'package:evira/utils/helpers/snack-bar.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  late final WishlistRepo _wishlistRepo;
  List<Product> _wishlistProducts = [];
  UserWishlist? _currentUserWishlist;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _wishlistRepo = WishlistRepo(wishlistDS: WishlistDS());
    print(
        '********************* WishlistController Created *********************');
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    print(
        '********************* WishlistController Ready *********************');
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    _wishlistProducts = [];
    _currentUserWishlist = null;
    print(
        '********************* WishlistController Closed *********************');
  }

  UserWishlist? get currentUserWishlist {
    return _currentUserWishlist;
  }

  static WishlistController get get => Get.find();

  List<Product> get wishlistProducts {
    return _wishlistProducts;
  }

  Future<void> getUserWishlist() async {
    try {
      final userWishlist = await _wishlistRepo.getUserWishlistFromRepo();
      if (userWishlist == null) {
        print('******************** userWishlist is Null ********************');
        return;
      }
      _currentUserWishlist = userWishlist;
      _wishlistProducts = ProductController.get.getWishlistProducts(
        userWishlist.wishlist,
      );
      print('*************** previewed _wishlistProducts ***********');
      print(_wishlistProducts);
    } catch (e) {
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', e.toString());
    }
  }

  Future<void> removeFromWishlist(String productId,
      {void Function()? onDone}) async {
    try {
      await _wishlistRepo.removeFromWishlist(productId);
      await getUserWishlist();
      if (onDone != null) {
        onDone();
      }
    } catch (e) {
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', e.toString());
    }
  }

  Future<void> addToWishlist(String productId,
      {void Function()? onDone}) async {
    try {
      await _wishlistRepo.addToWishlist(productId);
      await getUserWishlist();
      if (onDone != null) {
        onDone();
      }
    } catch (e) {
      showSnackbar(SnackbarState.danger, 'Something Went Wrong', e.toString());
    }
  }
}
