import 'package:cmp/controller/tasks/cubit/task_cubit.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/screens/employee/employee_task_replies_page.dart';
import 'package:cmp/presentation/widgets/employee_new_task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeTasks extends StatefulWidget {
  final int project_id;
  final int user_id;

  const EmployeeTasks({
    super.key,
    required this.project_id,
    required this.user_id,
  });

  @override
  State<EmployeeTasks> createState() => _EmployeeTasksState();
}

class _EmployeeTasksState extends State<EmployeeTasks> {
  int? projectUserId;

  @override
  void initState() {
    context.read<TaskCubit>().getUserTasksForSpecificProjet(
      widget.project_id,
      widget.user_id,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              context.read<TaskCubit>().getUserTasksForSpecificProjet(
                widget.project_id,
                widget.user_id,
              );
            },
          ),
        ],
        title: Text(
          "مهامي",
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        return EmployeeNewTaskCard(
                          taskModel: task,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EmployeeTaskRepliesPage(taskId: task.id),
                              ),
                            );
                            if (result == true) {
                              context
                                  .read<TaskCubit>()
                                  .getUserTasksForSpecificProjet(
                                    widget.project_id,
                                    widget.user_id,
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
    );
  }
}
