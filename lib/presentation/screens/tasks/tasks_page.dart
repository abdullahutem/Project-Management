import 'package:cmp/controller/tasks/cubit/task_cubit.dart';
import 'package:cmp/models/task_model.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key, required this.id});
  final int id;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  void initState() {
    final cubit = context.read<TaskCubit>();
    cubit.getAllTasks(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubit, TaskState>(
      listener: (context, state) {
        if (state is TaskError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
        // else if (state is ProjectDeletedSuccess) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text("تم حذف المشروع"),
        //       backgroundColor: Colors.green,
        //     ),
        //   );
        // }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'مهمه',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            backgroundColor: ColorManager.primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            elevation: 6,
            shadowColor: ColorManager.primaryColor.withOpacity(0.6),
          ),
          body: Builder(
            builder: (_) {
              if (state is TaskLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TaskLoaded) {
                final List<TaskModel> tasks = state.tasks;
                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          color: Colors.grey[400],
                          size: 80,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "لا توجد مهام لعرضها حاليًا.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "أضف مهام جديدة للبدء!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskCard(
                      task: task.task,
                      status: task.status,
                      isActive: task.is_active,
                      // projectName: task.project_name,
                      // userName: task.user_name,
                      onEdit: () {},
                      onDelete: () {},
                    );
                  },
                );
              } else if (state is TaskError) {
                return Center(child: Text('حدث خطأ: ${state.error}'));
              } else {
                return const SizedBox(); // default empty state
              }
            },
          ),
        );
      },
    );
  }
}
