import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/controller/tasks/cubit/task_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/screens/users/user_details_page.dart';
import 'package:cmp/presentation/widgets/beautiful_task_card.dart';
import 'package:cmp/presentation/widgets/project_card.dart';
import 'package:cmp/presentation/widgets/project_card_for_user.dart';
import 'package:cmp/repo/project_repo.dart';
import 'package:cmp/repo/task_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsWithProjectPage extends StatefulWidget {
  final UserModel user;
  const UserDetailsWithProjectPage({super.key, required this.user});

  @override
  State<UserDetailsWithProjectPage> createState() =>
      _UserDetailsWithProjectPageState();
}

class _UserDetailsWithProjectPageState
    extends State<UserDetailsWithProjectPage> {
  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.blue;
      case 'employee':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    context.read<ProjectCubit>().getPrjectsForSpecificUser(widget.user.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProjectCubit(ProjectRepo(api: DioConsumer(dio: Dio())))
            ..getPrjectsForSpecificUser(widget.user.id),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManager.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            widget.user.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
              fontFamily: "EXPOARABIC",
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Header
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: ColorManager.primaryColor.withOpacity(
                        0.8,
                      ),
                      child: Text(
                        widget.user.name[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          fontFamily: "EXPOARABIC",
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: "EXPOARABIC",
                      ),
                    ),
                    const SizedBox(height: 5),
                    Chip(
                      label: Text(
                        widget.user.role,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: "EXPOARABIC",
                        ),
                      ),
                      backgroundColor: _getRoleColor(widget.user.role),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // User Details Card
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تفاصيل الموظف',
                        style: const TextStyle(
                          color: ColorManager.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          fontFamily: "EXPOARABIC",
                        ),
                      ),
                      const Divider(height: 20, thickness: 1),
                      _buildDetailRow(
                        Icons.email,
                        'البريد الإلكتروني:',
                        widget.user.email,
                      ),
                      _buildDetailRow(
                        Icons.phone,
                        'رقم الهاتف:',
                        widget.user.phone,
                      ),
                      _buildDetailRow(
                        Icons.account_balance_wallet,
                        'الراتب الأساسي:',
                        '${widget.user.base_salary.toStringAsFixed(2)} ر.س',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Assigned Tasks Section
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                  'المشاريع المعينة',
                  style: const TextStyle(
                    color: ColorManager.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: "EXPOARABIC",
                  ),
                ),
              ),
              const Divider(height: 20, thickness: 1),
              BlocBuilder<ProjectCubit, ProjectState>(
                builder: (context, state) {
                  if (state is ProjectLoading) {
                    return CircularProgressIndicator();
                  } else if (state is ProjectError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(
                          state.error,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: "EXPOARABIC",
                          ),
                        ),
                      ),
                    );
                  } else if (state is ProjectsUserLoaded) {
                    final projects = state.project.projects;
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
                              fontFamily: "EXPOARABIC",
                            ),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          return ProjectCardForUser(
                            project: project,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailsPage(
                                    user: widget.user,
                                    project_id: project.id,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ColorManager.primaryColor, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: "EXPOARABIC",
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: "EXPOARABIC",
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
