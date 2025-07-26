import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/resources/styles_manager.dart';
import 'package:cmp/presentation/screens/dashboard_page.dart';
import 'package:cmp/presentation/screens/users/add_users_page.dart';
import 'package:cmp/presentation/screens/users/users_page.dart';
import 'package:cmp/presentation/screens/login.dart';
import 'package:cmp/presentation/screens/projects/add_project_page.dart';
import 'package:cmp/presentation/screens/projects/projects_page.dart';
import 'package:cmp/presentation/screens/tasks/add_task_page.dart';
import 'package:cmp/presentation/screens/tasks/tasks_page.dart';
import 'package:cmp/repo/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static const String login = '/';
  static const String usersPage = '/users';
  static const String addUsersPage = '/add_Users';
  static const String projectPage = '/project';
  static const String addProjectPage = '/add_project';
  static const String taskPage = '/task';
  static const String addTaskPage = '/add_task';
  static const String dashboardPage = '/dashboard_page';
}

class RoutesGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => Login());
      case Routes.usersPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                UserCubit(UserRepo(api: DioConsumer(dio: Dio())))
                  ..getAllUsers(),
            child: const UsersPage(),
          ),
        );
      case Routes.addUsersPage:
        return MaterialPageRoute(builder: (_) => AddUsersPage());
      case Routes.projectPage:
        return MaterialPageRoute(builder: (_) => ProjectsPage());
      case Routes.addProjectPage:
        return MaterialPageRoute(builder: (_) => AddProjectPage());
      case Routes.taskPage:
        return MaterialPageRoute(builder: (_) => TasksPage());
      case Routes.addTaskPage:
        return MaterialPageRoute(builder: (_) => AddTaskPage());
      case Routes.dashboardPage:
        return MaterialPageRoute(builder: (_) => DashboardPage());
      default:
        return undefindeRout();
    }
  }

  static Route<dynamic> undefindeRout() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(
            "noRouteFound",
            style: getRegelurTextStyle(color: ColorManager.primaryColor),
          ),
        ),
        body: Center(child: Text("No Page Found")),
      ),
    );
  }
}
