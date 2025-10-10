import 'package:cmp/controller/tasks/cubit/task_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/screens/employee/add_replies_task_page.dart';
import 'package:cmp/presentation/widgets/task_details_card.dart';
import 'package:cmp/presentation/widgets/task_replies_card_no_edit.dart';
import 'package:cmp/repo/task_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeTaskRepliesPage extends StatelessWidget {
  final int taskId;
  const EmployeeTaskRepliesPage({Key? key, required this.taskId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskRepo repo = TaskRepo(api: DioConsumer(dio: Dio()));
    return BlocProvider(
      create: (_) => TaskCubit(repo)..getSingeleTask(taskId),
      child: EmployeeTaskRepliesPageView(taskId: taskId),
    );
  }
}

class EmployeeTaskRepliesPageView extends StatefulWidget {
  final int taskId;

  const EmployeeTaskRepliesPageView({super.key, required this.taskId});

  @override
  State<EmployeeTaskRepliesPageView> createState() =>
      _EmployeeTaskRepliesPageViewState();
}

class _EmployeeTaskRepliesPageViewState
    extends State<EmployeeTaskRepliesPageView> {
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
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddRepliesTaskPage(task_id: widget.taskId),
                ),
              );
              if (result == true) {
                context.read<TaskCubit>().getSingeleTask(widget.taskId);
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'أضف رد',
              style: TextStyle(
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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<TaskCubit, TaskState>(
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
                      const SizedBox(height: 15),
                      // Fixed at top
                      TaskDetailsCard(singleTask: singleTask),
                      const SizedBox(height: 15),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                            children: [
                              Row(
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
                              const Divider(height: 20, thickness: 1),

                              // Replies list or empty state
                              if (singleTask.replies.isNotEmpty)
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: singleTask.replies.length,
                                  itemBuilder: (context, index) {
                                    final reply = singleTask.replies[index];
                                    return TaskRepliesCardNoEdit(
                                      replies: reply,
                                    );
                                  },
                                ),
                              if (singleTask.replies.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 20.0,
                                    ),
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
                              SizedBox(height: 200),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        );
      },
    );
  }
}
