import 'package:cmp/controller/project_user/cubit/project_user_cubit.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:cmp/presentation/screens/project_user/edit_project_user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProjectUserPage extends StatelessWidget {
  const ProjectUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            Routes.addProjectUserPage,
          );
          if (result == true) {
            context
                .read<ProjectUserCubit>()
                .getAllProjectUsers(); // Refresh list
          }
        },
      ),
      appBar: AppBar(title: const Text('Project Users')),
      body: BlocBuilder<ProjectUserCubit, ProjectUserState>(
        builder: (context, state) {
          if (state is ProjectUserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProjectUserLoaded) {
            final projectUsers = state.projectUsers;
            if (projectUsers.isEmpty) {
              return const Center(child: Text("No project users found."));
            }

            return ListView.builder(
              itemCount: projectUsers.length,
              itemBuilder: (context, index) {
                final projectUser = projectUsers[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(projectUser.cost_per_hour.toString()),
                    subtitle: Text('Assigned to: ${projectUser.max_hours}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProjectUserPage(
                                  model: projectUser,
                                  project_id: projectUser.project_id,
                                  user_id: projectUser.user_id,
                                ),
                              ),
                            );
                            if (result == true) {
                              context
                                  .read<ProjectUserCubit>()
                                  .getAllProjectUsers();
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: const Text(
                                  "Are you sure you want to delete this project-user record?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Navigator.of(ctx).pop();
                                      // context
                                      //     .read<ProjectUserCubit>()
                                      //     .deleteSingleProjectUser(
                                      //       projectUser.id,
                                      //     );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is ProjectUserError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const Center(child: Text("Unknown state"));
          }
        },
      ),
    );
  }
}
