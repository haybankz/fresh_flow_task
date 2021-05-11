
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:fresh_flow_task/layers/data/datasources/local_datasource.dart';
import 'package:fresh_flow_task/layers/data/datasources/remote_datasource.dart';
import 'package:fresh_flow_task/layers/data/repositories/item_repository_impl.dart';
import 'package:fresh_flow_task/layers/domain/repositories/item_repository.dart';
import 'package:fresh_flow_task/layers/domain/usecases/get_all_items.dart';
import 'package:fresh_flow_task/layers/local/datasources/local_datasource_impl.dart';
import 'package:fresh_flow_task/layers/network/datasources/remote_datasource_impl.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';


final sl = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();



  // * Domain Layer
  sl.registerFactory(() => GetAllItems(itemRepository: sl()));

  // * Data Layer
  sl.registerLazySingleton<ItemRepository>(
    () => ItemRepositoryImpl(
      localDatasource: sl(),
      remoteDatasource: sl(),
    ),
  );


  // * Network Layer
  sl.registerFactory<RemoteDatasource>(
      () => RemoteDatasourceImpl(fireCloud: sl()));

  // * Local Layer
  sl.registerFactory<LocalDatasource>(
      () => LocalDatasourceImpl(sharedPreferences: sl()));


  // * External
  final sharedPref = await SharedPreferences.getInstance();
  sl.registerFactory(() => sharedPref);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}