import 'package:cmp/cache/cache_helper.dart';
import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/resources/styles_manager.dart';
import 'package:cmp/presentation/screens/dashboard_page.dart';
import 'package:cmp/presentation/screens/employee/employee_projects.dart';
import 'package:cmp/presentation/screens/home_page.dart';
import 'package:cmp/presentation/screens/profile_page.dart';
import 'package:cmp/presentation/screens/projects/projects_dashbaord_page.dart';
import 'package:cmp/presentation/screens/report/report_page.dart';
import 'package:cmp/presentation/screens/users/add_users_page.dart';
import 'package:cmp/presentation/screens/users/users_dashbord_page.dart';
import 'package:cmp/presentation/screens/users/users_page.dart';
import 'package:cmp/presentation/screens/login.dart';
import 'package:cmp/presentation/screens/projects/add_project_page.dart';
import 'package:cmp/presentation/screens/projects/projects_page.dart';
import 'package:cmp/repo/project_repo.dart';
import 'package:cmp/repo/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static const String login = '/';
  static const String usersPage = '/users';
  static const String reportPage = '/report';
  static const String usersDashbaordPage = '/users_dashbaord';
  static const String addUsersPage = '/add_Users';
  // static const String addRepliesPage = '/add_Replies';
  static const String editUsersPage = '/edit_Users';
  static const String projectPage = '/project';
  static const String employeeProjectPage = '/employee_project';
  static const String projectDashbaordPage = '/project_dashbaord';
  static const String projectDetailsPage = '/project_details';
  static const String userDetailsPage = '/user_details';
  static const String addProjectPage = '/add_project';
  static const String addTaskPage = '/add_task';
  static const String dashboardPage = '/dashboard_page';
  static const String userdashboardPage = '/user_dashboard_page';
  static const String projectUserPage = '/project_user_page';
  static const String addProjectUserPage = '/add_project_user_page';
  static const String profilePage = '/profile_page';
  static const String homePage = '/home_page';
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
      case Routes.userdashboardPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                UserCubit(UserRepo(api: DioConsumer(dio: Dio())))
                  ..getAllUsers(),
            child: const UsersDashbordPage(),
          ),
        );
      case Routes.addUsersPage:
        return MaterialPageRoute(builder: (_) => AddUsersPage());
      case Routes.reportPage:
        return MaterialPageRoute(builder: (_) => ReportPage());
      case Routes.employeeProjectPage:
        return MaterialPageRoute(
          builder: (_) =>
              EmployeeProjects(id: CacheHelper().getData(key: ApiKeys.id)),
        );
      case Routes.projectPage:
        return MaterialPageRoute(builder: (_) => ProjectsPage());
      case Routes.projectDashbaordPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                ProjectCubit(ProjectRepo(api: DioConsumer(dio: Dio())))
                  ..getAllProjects(),
            child: const ProjectsDashbaordPage(),
          ),
        );
      case Routes.addProjectPage:
        return MaterialPageRoute(builder: (_) => AddProjectPage());
      case Routes.dashboardPage:
        return MaterialPageRoute(builder: (_) => DashboardPage());
      case Routes.profilePage:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case Routes.homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
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
