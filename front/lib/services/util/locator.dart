import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tutlayt/ql.dart';
import 'package:tutlayt/services/answer/answer_service.dart';
import 'package:tutlayt/services/api_service.dart';
import 'package:tutlayt/services/auth/auth.service.dart';
import 'package:tutlayt/services/controller.dart';
import 'package:tutlayt/services/question/question.service.dart';
import 'package:tutlayt/services/secured_store.service.dart';
import 'package:tutlayt/services/user/user.service.dart';

void registerServices() {
  Get.put(SecuredStoreService());
  Get.put(UserService());
  Get.put(ApiService());
  Get.put(AuthService());
  Get.put(QuestionService());
  Get.put(AnswerService());
  Get.put(Query(Get.find<ApiService>().query));
  Get.put(Mutation(Get.find<ApiService>().mutate));
  Get.put(Subscription(Get.find<ApiService>().subscribe));
  Get.put(Controller());
  Get.put(ImagePicker());
}
