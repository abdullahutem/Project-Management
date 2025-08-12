import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/models/project_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:cmp/presentation/screens/projects/edit_project_page.dart';
import 'package:cmp/presentation/screens/projects/project_details_page.dart';
import 'package:cmp/presentation/widgets/project_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

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
              content: Text("StringsManager.projectDeletedMessage"),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is SingleProjectLoaded) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailsPage(project: state.project),
            ),
          ).then((value) {
            context.read<ProjectCubit>().getAllProjects();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
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
                final List<ProjectModel> projects = state.projects;
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
                      itemCount: projects.length,
                      // In ProjectsPage, inside ListView.builder's itemBuilder:
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        return ProjectCard(
                          project: project,
                          onEdit: () async {
                            // This is your existing edit logic
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProjectPage(
                                  id: project.id,
                                  name: project.name,
                                  startDate: project.startDate,
                                  endDate: project.endDate,
                                  status: project.status,
                                  isActive: project.isActive,
                                ),
                              ),
                            );
                            if (result == true) {
                              context.read<ProjectCubit>().getAllProjects();
                            }
                          },
                          onDelete: () => context
                              .read<ProjectCubit>()
                              .deleteSingleProject(project.id),
                          onTap: () {
                            context.read<ProjectCubit>().getSingleProjects(
                              project.id,
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
                // context.read<ProjectCubit>().getAllProjects();
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
