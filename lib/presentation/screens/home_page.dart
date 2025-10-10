import 'package:cmp/cache/cache_helper.dart';
import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/controller/statistics/cubit/statistics_cubit.dart';
import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/models/projects_model.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:cmp/presentation/screens/employee/employee_tasks.dart';
import 'package:cmp/presentation/screens/projects/edit_project_page.dart';
import 'package:cmp/presentation/screens/projects/project_details_page.dart';
import 'package:cmp/presentation/screens/users/edit_users_page.dart';
import 'package:cmp/presentation/screens/users/user_details_with_project_page.dart';
import 'package:cmp/presentation/widgets/project_card_no_edit.dart';
import 'package:cmp/presentation/widgets/project_general_info_card.dart';
import 'package:cmp/presentation/widgets/project_general_info_card_no_edit.dart';
import 'package:cmp/presentation/widgets/side_menu.dart';
import 'package:cmp/presentation/widgets/user_general_info_card.dart';
import 'package:cmp/repo/project_repo.dart';
import 'package:cmp/repo/statistics_repo.dart';
import 'package:cmp/repo/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final statisticsRepo = StatisticsRepo(api: DioConsumer(dio: Dio()));
  final projectsRepo = ProjectRepo(api: DioConsumer(dio: Dio()));
  final usersRepo = UserRepo(api: DioConsumer(dio: Dio()));
  final role = CacheHelper().getDataString(key: ApiKeys.role);
  final userId = CacheHelper().getData(key: ApiKeys.id);
  final String? userName = CacheHelper().getDataString(key: ApiKeys.name);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              StatisticsCubit(statisticsRepo)..getStatisticsReport(),
        ),
        role == 'admin'
            ? BlocProvider(
                create: (context) =>
                    ProjectCubit(projectsRepo)..getFirstPageProjects(),
              )
            : BlocProvider(
                create: (context) =>
                    ProjectCubit(projectsRepo)
                      ..getProjectsForSpecificUser(userId),
              ),
        BlocProvider(
          create: (context) => UserCubit(usersRepo)..getFirstPageUsers(),
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
            ),
          ),
          backgroundColor: ColorManager.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          elevation: 6,
          shadowColor: ColorManager.primaryColor.withOpacity(0.6),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<StatisticsCubit, StatisticsState>(
                  builder: (context, state) {
                    if (state is LoadingStatistics) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ErrorStatistics) {
                      // Display an error message to the user
                      return Center(child: Text('Error: //${state.error}'));
                    } else if (state is LoadedStatistics) {
                      final model = state.satisticsModel;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_pin_circle_rounded,
                                    color: Colors.cyan.shade700,
                                    size: 26,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'مرحباً بك $userName',
                                    style: TextStyle(
                                      color: Colors.cyan.shade900,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'نظرة سريعة على بياناتك',
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Divider(
                                height: 30,
                                thickness: 1.5,
                                color: Colors.black12,
                              ),
                              _buildDataRow(
                                path: "assets/svgs/ProjectName.svg",
                                label: 'عدد المشاريع',
                                value: '${model.projects_count}',
                              ),

                              const SizedBox(height: 16),
                              _buildDataRow(
                                path: "assets/svgs/ActiveTasks.svg",
                                label: 'عدد المهام',
                                value: '${model.tasks_count}',
                              ),
                              const SizedBox(height: 16),
                              role == 'admin'
                                  ? _buildDataRow(
                                      path: "assets/svgs/EmployeesCounts.svg",
                                      label: 'عدد الموظفين',
                                      value: '${model.users_count}',
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),

                const SizedBox(height: 18),
                role == 'admin'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "المشاريع الحديثة",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: ColorManager.primaryColor,
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.projectPage);
                            },
                            child: const Text("عرض الكل"),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "المشاريع الحديثة",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: ColorManager.primaryColor,
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                Routes.employeeProjectPage,
                              );
                            },
                            child: const Text("عرض الكل"),
                          ),
                        ],
                      ),
                const SizedBox(height: 12),

                role == 'admin'
                    ? BlocBuilder<ProjectCubit, ProjectState>(
                        builder: (context, state) {
                          if (state is ProjectLoading) {
                            return const SizedBox(
                              height: 350,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (state is ProjectError) {
                            return SizedBox(
                              height: 420,
                              child: Center(child: Text(state.error)),
                            );
                          } else if (state is ProjectLoaded) {
                            final List<ProjectsModel> projects = state.projects;
                            if (projects.isEmpty) {
                              return const SizedBox(
                                height: 380,
                                child: Center(
                                  child: Text(
                                    "لا توجد مشاريع",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 260,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: projects.length,
                                  itemBuilder: (context, index) {
                                    final project = projects[index];
                                    return Container(
                                      margin: const EdgeInsets.only(left: 12.0),
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.85,
                                      child: ProjectGeneralInfoCard(
                                        projectModel: project,
                                        onEdit: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => EditProjectPage(
                                                id: project.project.id,
                                                name: project.project.name,
                                                startDate:
                                                    project.project.startDate,
                                                endDate:
                                                    project.project.endDate,
                                                status: project.project.status,
                                                isActive:
                                                    project.project.isActive,
                                              ),
                                            ),
                                          );
                                          if (result == true) {
                                            context
                                                .read<ProjectCubit>()
                                                .getFirstPageProjects();
                                          }
                                        },
                                        onDelete: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text("حذف"),
                                              content: const Text(
                                                "هل تريد حقا حذف المشروع؟",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(ctx).pop(),
                                                  child: const Text("إلغاء"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                    context
                                                        .read<ProjectCubit>()
                                                        .deleteSingleProject(
                                                          project.project.id,
                                                        );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Theme.of(
                                                              context,
                                                            ).colorScheme.error,
                                                        foregroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .onError,
                                                      ),
                                                  child: const Text("حذف"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        onTap: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProjectDetailsPage(
                                                    project_id:
                                                        project.project.id,
                                                    project_name:
                                                        project.project.name,
                                                  ),
                                            ),
                                          );
                                        },
                                        changeToActive: () {
                                          context
                                              .read<ProjectCubit>()
                                              .updateTaskStatus(
                                                project.project.id,
                                                'Active',
                                                project.project.isActive,
                                              );
                                        },
                                        changeToComplete: () {
                                          context
                                              .read<ProjectCubit>()
                                              .updateTaskStatus(
                                                project.project.id,
                                                'Completed',
                                                project.project.isActive,
                                              );
                                        },
                                        changeToPending: () {
                                          context
                                              .read<ProjectCubit>()
                                              .updateTaskStatus(
                                                project.project.id,
                                                'Pending',
                                                project.project.isActive,
                                              );
                                        },
                                        changeToTrue: () {
                                          context
                                              .read<ProjectCubit>()
                                              .updateTaskStatus(
                                                project.project.id,
                                                project.project.status,
                                                true,
                                              );
                                        },
                                        changeToFalse: () {
                                          context
                                              .read<ProjectCubit>()
                                              .updateTaskStatus(
                                                project.project.id,
                                                project.project.status,
                                                false,
                                              );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          }
                          return const SizedBox(height: 420);
                        },
                      )
                    : BlocBuilder<ProjectCubit, ProjectState>(
                        builder: (context, state) {
                          if (state is ProjectLoading) {
                            return CircularProgressIndicator();
                          } else if (state is ProjectError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                ),
                                child: Text(
                                  state.error,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          } else if (state is ProjectsUserLoaded) {
                            final projects = state.project;
                            if (projects.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: Text(
                                    'لا توجد مشاريع معينة لهذا الموظف.',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 260,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: projects.length,
                                  itemBuilder: (context, index) {
                                    final project = projects[index];

                                    return Container(
                                      margin: const EdgeInsets.only(left: 12.0),
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.85,
                                      child: ProjectGeneralInfoCardNoEdit(
                                        projectModel: project,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EmployeeTasks(
                                                    project_id:
                                                        project.project.id,
                                                    user_id: userId,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                const SizedBox(height: 12),
                role == 'admin'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "الموظفين الجدد",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: ColorManager.primaryColor,
                              fontSize: 18,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.usersPage);
                            },
                            child: const Text("عرض الكل"),
                          ),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(height: 12),
                role == 'admin'
                    ? BlocBuilder<UserCubit, UserState>(
                        builder: (context, state) {
                          if (state is UsersLoading) {
                            return const SizedBox(
                              height: 350,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (state is UsersFaliure) {
                            return SizedBox(
                              height: 420,
                              child: Center(child: Text(state.errormessage)),
                            );
                          } else if (state is UsersLoaded) {
                            final List<UserModel> users = state.usersList;
                            if (users.isEmpty) {
                              return const SizedBox(
                                height: 380,
                                child: Center(
                                  child: Text(
                                    "لا يوجد موظفين",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 260,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    final user = users[index];
                                    return Container(
                                      margin: const EdgeInsets.only(left: 12.0),
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.85,
                                      child: UserGeneralInfoCard(
                                        userModel: user,
                                        onEdit: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => EditUsersPage(
                                                name: user.name,
                                                email: user.email,
                                                phone: user.phone,
                                                id: user.id.toString(),
                                                salary: user.base_salary
                                                    .toString(),
                                                role: user.role,
                                              ),
                                            ),
                                          );
                                          if (result == true) {
                                            context
                                                .read<UserCubit>()
                                                .getFirstPageUsers();
                                          }
                                        },
                                        onDelete: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text("حذف"),
                                              content: const Text(
                                                "هل تريد حقا حذف المستخدم؟",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(ctx).pop(),
                                                  child: const Text("إلغاء"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                    context
                                                        .read<UserCubit>()
                                                        .deletelSingleUsers(
                                                          user.id,
                                                        );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Theme.of(
                                                              context,
                                                            ).colorScheme.error,
                                                        foregroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .onError,
                                                      ),
                                                  child: const Text("حذف"),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  UserDetailsWithProjectPage(
                                                    user_id: user.id,
                                                    user_name: user.name,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          }
                          return const SizedBox(height: 420);
                        },
                      )
                    : const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildDataRow({
  required String path,
  required String label,
  required String value,
}) {
  return Row(
    children: [
      SvgPicture.asset(path, width: 42, height: 42),
      const SizedBox(width: 16),
      Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      const Spacer(),
      Text(
        value,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}
