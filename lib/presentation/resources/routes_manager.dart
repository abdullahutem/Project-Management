import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/controller/project_user/cubit/project_user_cubit.dart';
import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/resources/styles_manager.dart';
import 'package:cmp/presentation/screens/dashboard_page.dart';
import 'package:cmp/presentation/screens/home_page.dart';
import 'package:cmp/presentation/screens/profile_page.dart';
import 'package:cmp/presentation/screens/user_dashboard_page.dart';
import 'package:cmp/presentation/screens/project_user/add_project_user_page.dart';
import 'package:cmp/presentation/screens/project_user/project_user_page.dart';
import 'package:cmp/presentation/screens/tasks/all_projects.dart';
import 'package:cmp/presentation/screens/users/add_users_page.dart';
import 'package:cmp/presentation/screens/users/users_page.dart';
import 'package:cmp/presentation/screens/login.dart';
import 'package:cmp/presentation/screens/projects/add_project_page.dart';
import 'package:cmp/presentation/screens/projects/projects_page.dart';
import 'package:cmp/repo/project_repo.dart';
import 'package:cmp/repo/project_user_repo.dart';
import 'package:cmp/repo/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Routes {
  static const String login = '/';
  static const String usersPage = '/users';
  static const String addUsersPage = '/add_Users';
  static const String editUsersPage = '/edit_Users';
  static const String projectPage = '/project';
  static const String projectDetailsPage = '/project_details';
  static const String userDetailsPage = '/user_details';
  static const String addProjectPage = '/add_project';
  static const String allProjects = '/AllProjects';
  static const String taskPage = '/task';
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
      case Routes.addUsersPage:
        return MaterialPageRoute(builder: (_) => AddUsersPage());
      // case Routes.editUsersPage:
      //   return MaterialPageRoute(builder: (_) => EditUsersPage());
      case Routes.projectPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                ProjectCubit(ProjectRepo(api: DioConsumer(dio: Dio())))
                  ..getAllProjects(),
            child: const ProjectsPage(),
          ),
        );
      case Routes.addProjectPage:
        return MaterialPageRoute(builder: (_) => AddProjectPage());
      case Routes.allProjects:
        return MaterialPageRoute(builder: (_) => AllProjects());
      // case Routes.projectDetailsPage:
      //   return MaterialPageRoute(
      //     builder: (_) => ProjectDetailsPage(
      //       project: ProjectModel(),
      //     ),
      //   );
      // case Routes.addTaskPage:
      //   return MaterialPageRoute(builder: (_) => AddTaskPage());
      case Routes.dashboardPage:
        return MaterialPageRoute(builder: (_) => DashboardPage());
      case Routes.userdashboardPage:
        return MaterialPageRoute(builder: (_) => UserDashboardPage());
      case Routes.projectUserPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                ProjectUserCubit(ProjectUserRepo(api: DioConsumer(dio: Dio())))
                  ..getAllProjectUsers(),
            child: const ProjectUserPage(),
          ),
        );
      case Routes.addProjectUserPage:
        return MaterialPageRoute(builder: (_) => AddProjectUserPage());
      // case Routes.userDetailsPage:
      //   return MaterialPageRoute(
      //     builder: (_) => UserDetailsPage(
      //       user: UserModel(
      //         id: 1,
      //         name: "name",
      //         email: "email",
      //         phone: "1212212",
      //         role: "admin",
      //         base_salary: 1212,
      //       ),
      //     ),
      //   );
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
