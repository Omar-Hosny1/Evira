import 'dart:convert';

import 'package:evira/controllers/auth-controller.dart';
import 'package:evira/data/data-sources/auth-ds.dart';
import 'package:evira/data/models/user.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/utils/helpers/error-handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final AuthDS authDataSource;
  AuthRepo._(this.authDataSource);

  static AuthRepo? _instance;

  static AuthRepo get instance {
    _instance ??= AuthRepo._(AuthDS());
    return _instance!;
  }

  Future<void> cleanUserDataFromSharedPrefs() async {
    await errorHandler(tryLogic: () async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final isRemoved =
          await sharedPreferences.remove(Strings.userDataKeySharedPrefrences);
      print('************* sharedPreferences.remove isRemoved *************');
      print(isRemoved);
    });
  }

  Future<User?> getUserDataFromSharedPrefs() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final getedUserData = sharedPreferences.getString(
      Strings.userDataKeySharedPrefrences,
    );
    if (getedUserData == null) {
      print('************* CANT FIND USER DATA *************');
      return null;
    }
    print('******************* GETTED USER DATA *******************');
    print(User.fromJson(json.decode(getedUserData)).getUserData());
    return User.fromJson(json.decode(getedUserData));
  }

  Future<void> _saveUserDataInPrefs(
    Object userData,
    String token, {
    bool? isSignIn,
  }) async {
    await errorHandler(tryLogic: () async {
      print('************_saveUserDataInPrefs Called ************');
      final sharedPreferences = await SharedPreferences.getInstance();

      if (isSignIn == true) {
        final userDataAsMap = (userData as Map);
        userDataAsMap['token'] = token;
        userDataAsMap['tokenExpiresIn'] =
            DateTime.now().add(const Duration(hours: 1)).toIso8601String();
        final encodedData = json.encode(userDataAsMap);
        await sharedPreferences.setString(
          Strings.userDataKeySharedPrefrences,
          encodedData,
        );
        return;
      }
      final encodedData = json.encode(userData);
      await sharedPreferences.setString(
        Strings.userDataKeySharedPrefrences,
        encodedData,
      );
    });
  }

  Future<void> signIn(String email, String password) async {
    await errorHandler(tryLogic: () async {
      await authDataSource.signIn(email, password, _saveUserDataInPrefs);
    });
  }

  Future<void> logout() async {
    await errorHandler(tryLogic: () async {
      await cleanUserDataFromSharedPrefs();
      await authDataSource.signOut();
    });
  }

  Future<void> signUp(User user) async {
    await errorHandler(
      tryLogic: () async {
        await authDataSource.signUp(user);
      },
      secondsToCancel: 45,
    );
  }

  Future<void> resetPassword(String email) async {
    await errorHandler(tryLogic: () async {
      await authDataSource.resetPassword(email);
    });
  }

  Future<void> updateUserData(User user) async {
    await errorHandler(
      tryLogic: () async {
        await authDataSource.updateUserData(user);
        await _saveUserDataInPrefs(user, user.getToken!);
      },
      secondsToCancel: 45,
    );
  }

  Future<void> deleteAccount() async {
    await errorHandler(
      tryLogic: () async {
        final user = AuthController.get.userData!;
        await authDataSource.deleteAccount(user);
      },
      secondsToCancel: 45,
    );
  }
}
