import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evira/controllers/products-controller.dart';
import 'package:evira/data/data-sources/wishlist-ds.dart';
import 'package:evira/data/models/firebase-models/user-wishlist.dart';
import 'package:evira/data/models/product.dart';
import 'package:evira/data/repositories/wishlist-repo.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/utils/helpers/error-handler.dart';
import 'package:evira/utils/helpers/snack-bar.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  late final WishlistRepo _wishlistRepo;
  UserWishlist? _currentUserWishlist;
  List<QueryDocumentSnapshot<Object?>> _wishlistProducts = [];

  List<QueryDocumentSnapshot<Object?>> get wishlistProducts {
    return [..._wishlistProducts];
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _wishlistRepo = WishlistRepo(wishlistDS: WishlistDS());
    // getUserWishlist();
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
    _currentUserWishlist = null;
    _wishlistProducts = [];
    print(
        '********************* WishlistController Closed *********************');
  }

  UserWishlist? get currentUserWishlist {
    return _currentUserWishlist;
  }

  static WishlistController get get => Get.find();

  Future<void> getUserWishlist() async {
    try {
      final userWishlist = await _wishlistRepo.getUserWishlistFromRepo();
      if (userWishlist == null || userWishlist.wishlist.isEmpty) {
        print('******************** userWishlist is Null ********************');
        return;
      }
      _currentUserWishlist = userWishlist;
      final data = await ProductController.get.getWishlistProducts(
        userWishlist.wishlist.keys.map((e) => int.parse(e)).toList(),
      );
      _wishlistProducts = data.docs;
      print('*************** previewed _wishlistProducts ***********');
      print(_wishlistProducts);
    } catch (e) {
      showSnackbar(
        SnackbarState.danger,
        'Something Went Wrong',
        formatErrorMessage(e.toString()),
      );
    }
  }

  Future<void> removeFromWishlist(String productId,
      {void Function()? onDone}) async {
    try {
      await _wishlistRepo.removeFromWishlist(productId);
      _wishlistProducts.removeWhere((element) {
        return Product.fromJson(element.data() as Map).id ==
            int.parse(productId);
      });
      _currentUserWishlist!.wishlist.remove(productId);
      update([Strings.wishlistGetBuilderId]);
      if (onDone != null) {
        onDone();
      }
    } catch (e) {
      showSnackbar(
        SnackbarState.danger,
        'Something Went Wrong',
        formatErrorMessage(
          e.toString(),
        ),
      );
    }
  }

  Future<void> addToWishlist(
    String productId, {
    void Function()? onDone,
  }) async {
    try {
      await _wishlistRepo.addToWishlist(productId);
      await getUserWishlist();
      if (onDone != null) {
        onDone();
      }
    } catch (e) {
      showSnackbar(
        SnackbarState.danger,
        'Something Went Wrong',
        formatErrorMessage(
          e.toString(),
        ),
      );
    }
  }
}
