import 'package:cmp/controller/tasks/cubit/task_cubit.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/screens/tasks/add_task_page.dart';
import 'package:cmp/presentation/screens/tasks/edit_task_page.dart';
import 'package:cmp/presentation/screens/tasks/task_replies_page.dart';
import 'package:cmp/presentation/widgets/new_task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsPage extends StatelessWidget {
  final int project_id;
  final UserModel user;

  const UserDetailsPage({
    super.key,
    required this.user,
    required this.project_id,
  });

  @override
  Widget build(BuildContext context) {
    context.read<TaskCubit>().getUserTasksForSpecificProjet(
      project_id,
      user.id,
    );

    return BlocConsumer<TaskCubit, TaskState>(
      listener: (context, state) {
        if (state is TaskDeletedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم حذف المهمة"),
              backgroundColor: Colors.green,
            ),
          );
          context.read<TaskCubit>().getUserTasksForSpecificProjet(
            project_id,
            user.id,
          );
        } else if (state is TaskUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم تحديث المهمة"),
              backgroundColor: Colors.green,
            ),
          );
          context.read<TaskCubit>().getUserTasksForSpecificProjet(
            project_id,
            user.id,
          );
        }
      },
      builder: (context, state) {
        int? projectUserId;
        if (state is TasksUserLoaded) {
          projectUserId = state.tasks.id;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorManager.primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_outlined),
                onPressed: () {
                  context.read<TaskCubit>().getUserTasksForSpecificProjet(
                    project_id,
                    user.id,
                  );
                },
              ),
            ],
            title: Text(
              user.name,
              style: const TextStyle(
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
                SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    '  المهام المعينة',
                    style: TextStyle(
                      color: ColorManager.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Divider(height: 20, thickness: 1),
                BlocBuilder<TaskCubit, TaskState>(
                  builder: (context, state) {
                    if (state is TaskLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TaskError) {
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
                    } else if (state is TasksUserLoaded) {
                      final assignedTasks = state.tasks.tasks;
                      if (assignedTasks.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              'لا توجد مهام معينة لهذا الموظف.',
                              style: TextStyle(
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
                          itemCount: assignedTasks.length,
                          itemBuilder: (context, index) {
                            final task = assignedTasks[index];
                            return NewTaskCard(
                              taskModel: task,
                              changeToActive: () {
                                context.read<TaskCubit>().updateTaskStatus(
                                  task.id.toString(),
                                  'Active',
                                  task.is_active,
                                );
                              },
                              changeToComplete: () {
                                context.read<TaskCubit>().updateTaskStatus(
                                  task.id.toString(),
                                  'Completted',
                                  task.is_active,
                                );
                              },
                              changeToPending: () {
                                context.read<TaskCubit>().updateTaskStatus(
                                  task.id.toString(),
                                  'Pending',
                                  task.is_active,
                                );
                              },
                              changeToTrue: () {
                                context.read<TaskCubit>().updateTaskStatus(
                                  task.id.toString(),
                                  task.status,
                                  true,
                                );
                              },
                              changeToFalse: () {
                                context.read<TaskCubit>().updateTaskStatus(
                                  task.id.toString(),
                                  task.status,
                                  false,
                                );
                              },
                              onEdit: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditTaskPage(
                                      id: task.id.toString(),
                                      task: task.task,
                                      status: task.status,
                                      isActive: task.is_active,
                                      projectUserId: task.project_user_id
                                          .toString(),
                                    ),
                                  ),
                                );
                                // if (result == true) {
                                //   context
                                //       .read<TaskCubit>()
                                //       .getUserTasksForSpecificProjet(
                                //         project_id,
                                //         user.id,
                                //       );
                                // }
                              },
                              onDelete: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("حذف"),
                                    content: const Text(
                                      "هل تريد حقا حذف المهمة؟",
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
                                              .read<TaskCubit>()
                                              .deletelSingleTask(task.id);
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
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TaskRepliesPage(taskId: task.id),
                                  ),
                                );
                                if (result == true) {
                                  context
                                      .read<TaskCubit>()
                                      .getUserTasksForSpecificProjet(
                                        project_id,
                                        user.id,
                                      );
                                }
                              },
                            );
                          },
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: projectUserId == null
                ? null // Disable the button if projectUserId is not yet loaded
                : () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddTaskPage(projectUserId: projectUserId!),
                      ),
                    );
                  },
            icon: const Icon(Icons.task, color: Colors.white),
            label: const Text(
              'أضف مهمة',
              style: TextStyle(color: Colors.white),
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
