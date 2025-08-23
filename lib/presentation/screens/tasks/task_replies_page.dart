import 'package:cmp/controller/tasks/cubit/task_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/widgets/task_replies_list.dart';
import 'package:cmp/repo/task_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Create this widget below

class TaskRepliesPage extends StatefulWidget {
  final int taskId;

  const TaskRepliesPage({super.key, required this.taskId});

  @override
  State<TaskRepliesPage> createState() => _TaskRepliesPageState();
}

class _TaskRepliesPageState extends State<TaskRepliesPage> {
  final TaskCubit taskCubit = TaskCubit(TaskRepo(api: DioConsumer(dio: Dio())));
  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().getSingeleTask(widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskState>(
      listener: (context, state) {
        if (state is TaskRepliesUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم تحديث المهمة"),
              backgroundColor: Colors.green,
            ),
          );
          context.read<TaskCubit>().getSingeleTask(widget.taskId);
        }
      },
      builder: (context, state) {
        // (context) => taskCubit..getSingeleTask(widget.taskId);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorManager.primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              'Task Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            elevation: 0,
          ),
          body: BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              if (state is TaskLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TaskError) {
                return Center(
                  child: Text(
                    state.error,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              } else if (state is SingleTaskLoaded) {
                final singleTask = state.task;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task Details Card
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
                              _buildDetailRow(
                                'Task Title',
                                singleTask.task.task,
                              ),
                              const Divider(height: 20, thickness: 1),
                              _buildDetailRow(
                                'Project',
                                singleTask.project_name,
                              ),
                              _buildDetailRow(
                                'Assigned To',
                                singleTask.user_name,
                              ),
                              _buildDetailRow('Status', singleTask.task.status),
                              _buildDetailRow('Cost', '${singleTask.cost} ر.س'),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),
                      // Task Replies Section
                      Row(
                        children: [
                          Text(
                            'عدد الردود: ',
                            style: const TextStyle(
                              color: ColorManager.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            singleTask.replies_count.toString(),
                            style: const TextStyle(
                              color: ColorManager.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20, thickness: 1),
                      if (singleTask.replies.isNotEmpty)
                        TaskRepliesList(
                          replies: singleTask.replies,
                          changeToRejected: (index) {
                            context.read<TaskCubit>().updateRepliesTaskStatus(
                              singleTask.replies[index].id.toString(),
                              'Rejected',
                            );
                          },
                          changeToApproved: (index) {
                            context.read<TaskCubit>().updateRepliesTaskStatus(
                              singleTask.replies[index].id.toString(),
                              'Approved',
                            );
                          },
                          changeToSubmitted: (index) {
                            context.read<TaskCubit>().updateRepliesTaskStatus(
                              singleTask.replies[index].id.toString(),
                              'Submitted',
                            );
                          },
                        )
                      else
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              'No replies yet.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
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
