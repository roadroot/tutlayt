import 'package:get/get.dart';
import 'package:tutlayt/ql.dart';
import 'package:tutlayt/services/secured_store.service.dart';

class UserService {
  /// get the current logged user
  Future<User?> get user => SecuredStoreService().currentUser;

  /// get the user with id [userId]
  /// or return the current logged user if there is one and if
  /// [userId] is null
  Future<User?> getUser({
    String? userId,
  }) async {
    if (userId == null) {
      return await user;
    }
    // await Future.delayed(const Duration(seconds: 3)); // TODO: remove this
    return await Get.find<Query>().user(const UserSelector(), userId);
  }
}
