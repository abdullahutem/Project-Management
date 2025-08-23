import 'package:cmp/controller/tasks/cubit/task_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/screens/tasks/add_task_page.dart';
import 'package:cmp/presentation/screens/tasks/edit_task_page.dart';
import 'package:cmp/presentation/screens/tasks/task_replies_page.dart';
import 'package:cmp/presentation/widgets/beautiful_task_card.dart';
import 'package:cmp/repo/task_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsPage extends StatefulWidget {
  final int project_id;
  final UserModel user;

  const UserDetailsPage({
    super.key,
    required this.user,
    required this.project_id,
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final TaskCubit taskCubit = TaskCubit(TaskRepo(api: DioConsumer(dio: Dio())));
  int? projectUserId;
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
    print("widget.project_id=====================${widget.project_id}");
    context.read<TaskCubit>().getUserTasksForSpecificProjet(
      widget.project_id,
      widget.user.id,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            widget.project_id,
            widget.user.id,
          );
        } else if (state is TaskUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم تحديث المهمة"),
              backgroundColor: Colors.green,
            ),
          );
          context.read<TaskCubit>().getUserTasksForSpecificProjet(
            widget.project_id,
            widget.user.id,
          );
        }
      },
      builder: (context, state) {
        // (context) => taskCubit
        //   ..getUserTasksForSpecificProjet(widget.project_id, widget.user.id);
        return Scaffold(
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
                    'المهام المعينة',
                    style: const TextStyle(
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
                      return CircularProgressIndicator();
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
                      projectUserId = state.tasks.id;
                      if (assignedTasks.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              'لا توجد مهام معينة لهذا الموظف.',
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
                          itemCount: assignedTasks.length,
                          itemBuilder: (context, index) {
                            final task = assignedTasks[index];

                            return BeautifulTaskCard(
                              task: task,
                              changeToActive: () {
                                context.read<TaskCubit>().updateTaskStatus(
                                  task.id.toString(),
                                  'active',
                                  task.is_active,
                                );
                              },
                              changeToComplete: () {
                                context.read<TaskCubit>().updateTaskStatus(
                                  task.id.toString(),
                                  'completed',
                                  task.is_active,
                                );
                              },
                              changeToPending: () {
                                context.read<TaskCubit>().updateTaskStatus(
                                  task.id.toString(),
                                  'pending',
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
                                final result = await Navigator.push(
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
                                if (result == true) {
                                  context
                                      .read<TaskCubit>()
                                      .getUserTasksForSpecificProjet(
                                        widget.project_id,
                                        widget.user.id,
                                      );
                                }
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
                                final result = await await Navigator.push(
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
                                        widget.project_id,
                                        widget.user.id,
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
                SizedBox(height: 100),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
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
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
