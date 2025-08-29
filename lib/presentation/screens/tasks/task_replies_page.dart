import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/repo/task_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Create this widget below

import 'package:cmp/controller/tasks/cubit/task_cubit.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/widgets/task_details_card.dart';
import 'package:cmp/presentation/widgets/task_replies_card.dart';

class TaskRepliesPage extends StatelessWidget {
  final int taskId;
  const TaskRepliesPage({Key? key, required this.taskId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskRepo repo = TaskRepo(api: DioConsumer(dio: Dio()));
    return BlocProvider(
      create: (_) => TaskCubit(repo)..getSingeleTask(taskId),
      child: TaskRepliesPageView(taskId: taskId),
    );
  }
}

class TaskRepliesPageView extends StatefulWidget {
  final int taskId;

  const TaskRepliesPageView({super.key, required this.taskId});

  @override
  State<TaskRepliesPageView> createState() => _TaskRepliesPageStateView();
}

class _TaskRepliesPageStateView extends State<TaskRepliesPageView> {
  // @override
  // void initState() {
  //   super.initState();
  //   context.read<TaskCubit>().getSingeleTask(widget.taskId);
  // }

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
                return Column(
                  children: [
                    // Fixed at top
                    TaskDetailsCard(singleTask: singleTask),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            'عدد الردود: ',
                            style: TextStyle(
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
                    ),
                    const Divider(height: 20, thickness: 1),

                    if (singleTask.replies.isNotEmpty) ...[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: singleTask.replies.length,
                            itemBuilder: (context, index) {
                              final singleask = singleTask.replies[index];
                              return TaskRepliesCard(
                                replies: singleask,
                                changeToRejected: () {
                                  context
                                      .read<TaskCubit>()
                                      .updateRepliesTaskStatus(
                                        singleask.id,
                                        'Rejected',
                                      );
                                },
                                changeToApproved: () {
                                  context
                                      .read<TaskCubit>()
                                      .updateRepliesTaskStatus(
                                        singleask.id,
                                        'Approved',
                                      );
                                },
                                changeToSubmitted: () {
                                  context
                                      .read<TaskCubit>()
                                      .updateRepliesTaskStatus(
                                        singleask.id,
                                        'Submitted',
                                      );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ] else if (singleTask.replies.isEmpty)
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
                );
              }

              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
