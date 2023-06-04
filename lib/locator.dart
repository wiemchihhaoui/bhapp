import 'package:get_it/get_it.dart';

import 'core/services/category_icon_service.dart';
import 'core/viewmodels/home_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  //!SERVICES
  locator.registerLazySingleton(() => CategoryIconService());
/*  locator.registerLazySingleton(() => MoorDatabaseService());
  locator.registerLazySingleton(() => NotificationService());*/
  //!VIEWMODELS
  locator.registerFactory(() => HomeModel());
/*  locator.registerFactory(() => DetailsModel());
  locator.registerFactory(() => EditModel());*/
/*  locator.registerFactory(() => InsertTransactionModel());
  locator.registerFactory(() => PieChartModel());
  locator.registerFactory(() => ReminderModel());*/
}
