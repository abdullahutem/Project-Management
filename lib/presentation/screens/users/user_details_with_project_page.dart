import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/screens/users/user_details_page.dart';
import 'package:cmp/presentation/widgets/employee_project_card.dart';
import 'package:cmp/repo/project_repo.dart';
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
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Text(
                  'المشاريع المعينة',
                  style: const TextStyle(
                    color: ColorManager.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
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
                          return EmployeeProjectCard(
                            projectModel: project,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailsPage(
                                    user: widget.user,
                                    project_id: project.project.id,
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
}
