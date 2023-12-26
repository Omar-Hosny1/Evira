import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/data/data-sources/wishlist-ds.dart';
import 'package:evira/utils/constants/values.dart';
import 'package:evira/utils/helpers/error-handler.dart';
import '../models/firebase-models/user-wishlist.dart';

class WishlistRepo {
  final WishlistDS wishlistDS;
  WishlistRepo._(this.wishlistDS);

  static WishlistRepo? _instance;

  static WishlistRepo get instance {
    _instance ??= WishlistRepo._(WishlistDS());
    return _instance!;
  }

  Future<UserWishlist?> getUserWishlistFromRepo() async {
    return await errorHandler<UserWishlist?>(tryLogic: () async {
      final userEmail = AuthController.get.userData!.getEmail!;
      print('****************** USER EMAIL ***************');
      print(userEmail);
      final userWishlistDoc = await wishlistDS.getUserWishlist(userEmail);
      if (userWishlistDoc == null) {
        return null;
      }
      final userWishlistData = userWishlistDoc.data() as Map<String, dynamic>;
      print('*************************** UserWishlist ***************** ');
      print(UserWishlist.fromJson(userWishlistData).toJson());
      return UserWishlist.fromJson(userWishlistData);
    });
  }

  Future<void> removeFromWishlist(String productId) async {
    await errorHandler(tryLogic: () async {
      final userEmail = AuthController.get.userData!.getEmail!;
      await wishlistDS.removeFromWishlist(userEmail, productId);
    });
  }

  Future<void> addToWishlist(String productId) async {
    await errorHandler(tryLogic: () async {
      final userEmail = AuthController.get.userData!.getEmail!;
      await wishlistDS.addToWishlist(userEmail, productId);
    });
  }

  Future<void> deleteUserOrders() async {
    await errorHandler(
      tryLogic: () async {
        final user = AuthController.get.userData!;
        await wishlistDS.deleteUserWishlist(user);
      },
      secondsToCancel: Values.medlongOperationsSecondsToCancle,
    );
  }
}
