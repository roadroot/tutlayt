import 'package:get_it/get_it.dart';
import 'package:tutlayt/ql.dart';
import 'package:tutlayt/services/api_service.dart';
import 'package:tutlayt/services/auth/auth.service.dart';
import 'package:tutlayt/services/question/question.service.dart';
import 'package:tutlayt/services/secured_store.service.dart';
import 'package:tutlayt/services/user/user.service.dart';

void setupGetIt() {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton(() => SecuredStoreService());
  getIt.registerLazySingleton(() => UserService());
  getIt.registerLazySingleton(() => ApiService());
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => QuestionService());
  getIt.registerLazySingleton(() => Query(getIt.get<ApiService>().executor));
  getIt.registerLazySingleton(() => Mutation(getIt.get<ApiService>().executor));
}
