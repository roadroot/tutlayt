import 'package:get/get.dart';
import 'package:tutlayt/ql.dart';
import 'package:tutlayt/services/user/user.service.dart';

class Controller extends GetxController {
  @override
  void onInit() {
    super.onInit();
    ever(userObs, (User? user) {
      if (user != null) {
        Get.snackbar('Connected', 'You are connected');
      } else {
        Get.snackbar('Disconnected', 'You are disconnected');
      }
    });
    Get.find<UserService>().user.then((User? user) {
      userObs(user);
    });
  }

  Rxn<User?> userObs = Rxn<User?>(null);
  bool get connected => userObs.value != null;
  User? get user => userObs.value;
  set user(User? user) {
    userObs.value = user;
    userObs.refresh();
  }
}
