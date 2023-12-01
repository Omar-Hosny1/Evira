import 'dart:convert';

import 'package:evira/data/data-sources/auth-ds.dart';
import 'package:evira/data/models/user.dart';
import 'package:evira/utils/constants/strings.dart';
import 'package:evira/utils/helpers/error-handler.dart';
import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final AuthDS authDataSource;
  AuthRepo({required this.authDataSource});

  listenToUserStates(void Function(FA.User?)? onData) {
    authDataSource.listenToUserStates(onData);
  }

  Future<void> cleanUserDataFromSharedPrefs() async {
    await errorHandler(tryLogic: () async {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.remove(Strings.userDataKeySharedPrefrences);
    });
  }

  Future<User> getUserDataFromSharedPrefs() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final getedUserData = sharedPreferences.getString(
      Strings.userDataKeySharedPrefrences,
    );
    return User.fromJson(json.decode(getedUserData!));
  }

  Future<void> _saveUserDataInPrefs(Object userData) async {
    await errorHandler(tryLogic: () async {
      final sharedPreferences = await SharedPreferences.getInstance();
      final encodedData = json.encode(userData);
      final isSavedSuccessfully = await sharedPreferences.setString(
        Strings.userDataKeySharedPrefrences,
        encodedData,
      );
      if (isSavedSuccessfully == false) {
        throw Exception('Data Can\'t Saved Locally in this Device');
      }
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
    await errorHandler(tryLogic: () async {
      await authDataSource.signUp(user);
      await signIn(user.getEmail!, user.getPassword!);
    });
  }
}
