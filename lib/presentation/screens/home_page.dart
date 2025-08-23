import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/models/project_model.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:cmp/presentation/widgets/dashboard_card.dart';
import 'package:cmp/presentation/widgets/side_menu.dart';
import 'package:cmp/repo/project_repo.dart';
import 'package:cmp/repo/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userRepo = UserRepo(api: DioConsumer(dio: Dio()));
  final projectRepo = ProjectRepo(api: DioConsumer(dio: Dio()));
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
          create: (_) {
            final cubit = UserCubit(userRepo);
            cubit.getAllUsers();
            return cubit;
          },
        ),
        BlocProvider<ProjectCubit>(
          create: (_) {
            final cubit = ProjectCubit(projectRepo);
            cubit.getAllProjects();
            return cubit;
          },
        ),
      ],
      child: Scaffold(
        drawer: SideMenu(),
        appBar: AppBar(
          title: const Text(
            'الرئيسية',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              fontFamily: "EXPOARABIC",
            ),
          ),
          backgroundColor: ColorManager.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 6,
          shadowColor: ColorManager.primaryColor.withOpacity(0.6),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey.shade100, Colors.white],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Prominent Welcome Section
                Text(
                  'مرحباً بك!',
                  style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: "EXPOARABIC",
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'نظرة سريعة على بياناتك',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "EXPOARABIC",
                  ),
                ),
                const SizedBox(height: 30), // More space before cards

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0, // Increased spacing
                    mainAxisSpacing: 20.0, // Increased spacing
                    childAspectRatio:
                        0.9, // Adjust card ratio for a slightly taller look
                    children: [
                      BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          if (state is UsersLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is UsersLoaded) {
                            final List<UserModel> employees = state.usersList;
                            return DashboardCard(
                              icon: Icons.groups_2_outlined,
                              label: 'الموظفين',
                              count: employees.length,
                              baseColor: Colors.blue.shade700,
                              function: () {
                                // Navigator.pushNamed(context, Routes.usersPage);
                              },
                            );
                          } else if (state is UsersFaliure) {
                            return Center(
                              child: Text('حدث خطأ: ${state.errormessage}'),
                            );
                          } else {
                            return const Center(
                              child: Text("No data"),
                            ); // default empty state
                          }
                        },
                      ),
                      BlocBuilder<ProjectCubit, ProjectState>(
                        builder: (context, state) {
                          if (state is ProjectLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is ProjectLoaded) {
                            final List<ProjectModel> projects = state.projects;
                            return DashboardCard(
                              icon: Icons.business_center_outlined,
                              label: 'المشاريع',
                              count: projects.length,
                              baseColor: Colors.greenAccent.shade700,
                              function: () {
                                // Navigator.pushNamed(
                                //   context,
                                //   Routes.projectPage,
                                // );
                              },
                            );
                          } else if (state is ProjectError) {
                            return Center(
                              child: Text('حدث خطأ: ${state.error}'),
                            );
                          } else {
                            return const Center(
                              child: Text("No data"),
                            ); // default empty state
                          }
                        },
                      ),
                      DashboardCard(
                        icon: Icons.checklist_rtl_outlined,
                        label: 'المهام',
                        count: 23,
                        baseColor: Colors.orange.shade700,
                        function: () {
                          Navigator.pushNamed(context, Routes.taskPage);
                        },
                      ),
                      DashboardCard(
                        icon:
                            Icons.analytics_outlined, // Modern icon for reports
                        label: 'التقارير',
                        count: 12, // Still supports no count
                        baseColor: Colors.purple.shade700,
                        function: () {
                          // Implement navigation to reports page
                          // Navigator.pushNamed(context, Routes.reportsPage);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
