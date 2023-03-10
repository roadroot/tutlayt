import 'package:get_it/get_it.dart';
import 'package:tutlayt/services/api_service.dart';
import 'package:tutlayt/services/secured_store.service.dart';
import 'package:tutlayt/services/user/user.service.dart';

void setupGetIt() {
  final getIt = GetIt.instance;
  getIt.registerLazySingleton(() => SecuredStoreService());
  getIt.registerLazySingleton(() => UserService());
  getIt.registerLazySingleton(() => ApiService());
}
