import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/presentation/screens/project_user/add_project_user_page.dart';
import 'package:cmp/presentation/widgets/user_card_no_edit.dart';
import 'package:cmp/repo/project_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/screens/users/user_details_page.dart';

class ProjectDetailsPage extends StatelessWidget {
  final int project_id;
  final String project_name;

  const ProjectDetailsPage({
    Key? key,
    required this.project_id,
    required this.project_name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProjectRepo repo = ProjectRepo(api: DioConsumer(dio: Dio()));
    return BlocProvider(
      create: (_) => ProjectCubit(repo)..getSingleProjects(project_id),
      child: ProjectDetailsView(
        project_id: project_id,
        project_name: project_name,
      ),
    );
  }
}

class ProjectDetailsView extends StatefulWidget {
  final int project_id;
  final String project_name;
  const ProjectDetailsView({
    Key? key,
    required this.project_id,
    required this.project_name,
  }) : super(key: key);

  @override
  State<ProjectDetailsView> createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends State<ProjectDetailsView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<ProjectCubit>()..getSingleProjects(widget.project_id),
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProjectUserPage(
                  projectid: widget.project_id,
                  ptojectName: widget.project_name,
                ),
              ),
            );
            if (result == true) {
              context.read<ProjectCubit>().getSingleProjects(widget.project_id);
            }
          },
          icon: const Icon(Icons.person_add, color: Colors.white),
          label: const Text(
            'أضف موظف للمشروع',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: ColorManager.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          backgroundColor: ColorManager.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            widget.project_name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              onPressed: () {
                context.read<ProjectCubit>().getSingleProjects(
                  widget.project_id,
                );
              },
            ),
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<ProjectCubit, ProjectState>(
            builder: (context, state) {
              if (state is SingleProjectLoaded) {
                final project = state.project;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '   أعضاء الفريق المعينون',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.primaryColor,
                      ),
                    ),
                    const Divider(height: 20, thickness: 1),
                    if (project.users.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                            'لا يوجد موظفون معينون لهذا المشروع.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: project.users.length,
                        itemBuilder: (context, index) {
                          final user = project.users[index];
                          return UserCardNoEdit(
                            userModel: user,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDetailsPage(
                                    user: user,
                                    project_id: project.projectModel.id,
                                  ),
                                ),
                              );
                            },
                            onEdit: () {},
                            onDelete: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("حذف"),
                                  content: const Text(
                                    "هل تريد حقا حذف المستخدم من المشروع؟",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: const Text("إلغاء"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                        context
                                            .read<ProjectCubit>()
                                            .deleteSingleProjectUser(
                                              project.projectModel.id,
                                              user.id,
                                            );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "تم حذف المشروع بنجاح",
                                            ),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                        foregroundColor: Theme.of(
                                          context,
                                        ).colorScheme.onError,
                                      ),
                                      child: const Text("حذف"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    SizedBox(height: 100),
                  ],
                );
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'لا يوجد موظفون معينون لهذا المشروع.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
