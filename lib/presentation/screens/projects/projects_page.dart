import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/models/projects_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:cmp/presentation/screens/projects/edit_project_page.dart';
import 'package:cmp/presentation/screens/projects/project_details_page.dart';
import 'package:cmp/presentation/widgets/new_project_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProjectCubit>().getFirstPageProjects();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 20) {
        context.read<ProjectCubit>().loadMoreProjects();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectState>(
      listener: (context, state) {
        if (state is ProjectError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else if (state is ProjectDeletedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم حذف المشروع بنجاح"),
              backgroundColor: ColorManager.primaryColor,
            ),
          );
        } else if (state is ProjectUpdatedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم تحديث المهمة"),
              backgroundColor: Colors.green,
            ),
          );
          context.read<ProjectCubit>().getFirstPageProjects();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "المشاريع",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            centerTitle: true,
            backgroundColor: ColorManager.primaryColor,
            elevation: 0,
          ),
          body: Builder(
            builder: (_) {
              if (state is ProjectLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProjectLoaded) {
                final List<ProjectsModel> projects = state.projects;
                if (projects.isEmpty) {
                  return const Center(
                    child: Text(
                      "StringsManager.noData",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: projects.length,
                      // In ProjectsPage, inside ListView.builder's itemBuilder:
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        return NewProjectCard(
                          projectModel: project,
                          onEdit: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProjectPage(
                                  id: project.project.id,
                                  name: project.project.name,
                                  startDate: project.project.startDate,
                                  endDate: project.project.endDate,
                                  status: project.project.status,
                                  isActive: project.project.isActive,
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
                                content: const Text("هل تريد حقا حذف المشروع؟"),
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
                                          .deleteSingleProject(
                                            project.project.id,
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
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProjectDetailsPage(
                                  project_id: project.project.id,
                                  project_name: project.project.name,
                                ),
                              ),
                            );
                          },
                          changeToActive: () {
                            context.read<ProjectCubit>().updateTaskStatus(
                              project.project.id,
                              'Active',
                              project.project.isActive,
                            );
                          },
                          changeToComplete: () {
                            context.read<ProjectCubit>().updateTaskStatus(
                              project.project.id,
                              'Completed',
                              project.project.isActive,
                            );
                          },
                          changeToPending: () {
                            context.read<ProjectCubit>().updateTaskStatus(
                              project.project.id,
                              'Pending',
                              project.project.isActive,
                            );
                          },
                          changeToTrue: () {
                            context.read<ProjectCubit>().updateTaskStatus(
                              project.project.id,
                              project.project.status,
                              true,
                            );
                          },
                          changeToFalse: () {
                            context.read<ProjectCubit>().updateTaskStatus(
                              project.project.id,
                              project.project.status,
                              false,
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              } else if (state is ProjectError) {
                return Center(
                  child: Text(
                    'حدث خطأ: ${state.error}',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                Routes.addProjectPage,
              );
              if (result == true) {
                context.read<ProjectCubit>().getFirstPageProjects();
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'أضف مشروع',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: ColorManager.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
