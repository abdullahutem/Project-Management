import 'package:cmp/cache/cache_helper.dart';
import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/controller/project_user/cubit/project_user_cubit.dart';
import 'package:cmp/controller/tasks/cubit/task_cubit.dart';
import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:cmp/repo/project_repo.dart';
import 'package:cmp/repo/project_user_repo.dart';
import 'package:cmp/repo/task_repo.dart';
import 'package:cmp/repo/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper().init();

  // Get token
  final token = CacheHelper().getDataString(key: ApiKeys.token);
  final role = CacheHelper().getDataString(key: ApiKeys.role);

  // Decide the initial route
  final String initialRoute = token == null || token.isEmpty
      ? Routes.login
      : role == 'admin'
      ? Routes.homePage
      : Routes.userdashboardPage;
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(UserRepo(api: DioConsumer(dio: Dio()))),
        ),
        BlocProvider<ProjectCubit>(
          create: (_) =>
              ProjectCubit(ProjectRepo(api: DioConsumer(dio: Dio()))),
        ),
        BlocProvider<ProjectUserCubit>(
          create: (_) =>
              ProjectUserCubit(ProjectUserRepo(api: DioConsumer(dio: Dio()))),
        ),
        BlocProvider<TaskCubit>(
          create: (_) => TaskCubit(TaskRepo(api: DioConsumer(dio: Dio()))),
        ),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar'), Locale('en')],
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RoutesGenerator.getRoute,
      initialRoute: initialRoute,
      theme: ThemeData(fontFamily: "EXPOARABIC"),
    );
  }
}
