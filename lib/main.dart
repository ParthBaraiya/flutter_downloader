import 'package:downloader/services/local_database_respository/local_database_repository.dart';
import 'package:downloader/services/navigation_service/navigation_service.dart';
import 'package:flutter/material.dart';

void main() {
  AppConfigs.init(
    database: LocalDatabaseRepository(folder: 'data'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: NavigationService.router,
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class AppConfigs {
  final LocalDatabaseRepositoryInterface _database;

  AppConfigs._({
    required LocalDatabaseRepositoryInterface database,
  }) : _database = database;

  factory AppConfigs.init({
    required LocalDatabaseRepositoryInterface database,
  }) {
    _instance = _instance ?? AppConfigs._(database: database);

    return _instance!;
  }
  static AppConfigs? _instance;

  static LocalDatabaseRepositoryInterface get database => _instance!._database;
}
