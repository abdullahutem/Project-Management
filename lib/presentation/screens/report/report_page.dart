import 'package:cmp/controller/financial_report/cubit/financial_report_cubit.dart';
import 'package:cmp/controller/project/cubit/project_cubit.dart';
import 'package:cmp/controller/tasks/cubit/task_cubit.dart';
import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/core/api/dio_consumer.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/widgets/custom_dropdown_field.dart';
import 'package:cmp/presentation/widgets/custom_text_field.dart';
import 'package:cmp/repo/financial_report_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final financialRepo = FinancialReportRepo(api: DioConsumer(dio: Dio()));
  @override
  void initState() {
    final userCubit = context.read<UserCubit>();
    final projectCubit = context.read<ProjectCubit>();
    context.read<FinancialReportCubit>().getFinancialReportAdvance();
    userCubit.getAllUserNames();
    projectCubit.getAllProjectsNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FinancialReportCubit>();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "التقارير",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: ColorManager.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              context.read<FinancialReportCubit>().getFinancialReport();
              cubit.selectedProjectId = null;
              cubit.selectedUserId = null;
              cubit.selectedTaskId = null;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "المشروع",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              customDropdownField(
                value: (cubit.selectedProjectId != null)
                    ? cubit.selectedProjectId
                    : null,
                items: context.watch<ProjectCubit>().projectsList.map((p) {
                  return DropdownMenuItem(
                    value: p.project.id.toString(),
                    child: Text(p.project.name),
                  );
                }).toList(),
                onChanged: (val) => cubit.selectedProjectId = val ?? '',
              ),
              const SizedBox(height: 10),
              const Text(
                "المستخدم",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        if (state is UsersFaliure) {
                          return Text("Error");
                        } else if (state is UsersLoaded) {
                          final users = state.usersList;
                          return customDropdownField(
                            value: (users.first.id).toString(),
                            items: context.watch<UserCubit>().usersList.map((
                              u,
                            ) {
                              return DropdownMenuItem(
                                value: u.id.toString(),
                                child: Text(u.name),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                cubit.selectedUserId = val ?? '',
                          );
                        } else if (state is SingleUserProjectLoaded) {
                          final users = state.users;
                          if (users.isNotEmpty) {
                            return customDropdownField(
                              value: (users.first.id).toString(),
                              items: context
                                  .watch<UserCubit>()
                                  .usersForSingleProjectList
                                  .map((u) {
                                    return DropdownMenuItem(
                                      value: u.id.toString(),
                                      child: Text(u.name),
                                    );
                                  })
                                  .toList(),
                              onChanged: (val) =>
                                  cubit.selectedUserId = val ?? '',
                            );
                          } else {
                            return Center(
                              child: Text("لا يوجد موظفين في لهذا المشروع"),
                            );
                          }
                        } else {
                          return Center(child: Text("No Data"));
                        }
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final projectId =
                          int.tryParse(cubit.selectedProjectId ?? '0') ?? 0;
                      context.read<UserCubit>().getSingleProjects(projectId);
                    },
                    icon: Icon(Icons.refresh),
                  ),
                  // SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      cubit.selectedUserId = null;
                      context.read<UserCubit>().getAllUsers();
                    },
                    icon: Icon(Icons.cancel, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const Text(
                "المهمه",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: BlocBuilder<TaskCubit, TaskState>(
                      builder: (context, state) {
                        if (state is TaskError) {
                          return const Text("Error");
                        } else if (state is TaskLoading) {
                          return const CircularProgressIndicator();
                        } else if (state is TasksUserLoaded) {
                          final assignedTasks = state.tasks.tasks;
                          if (assignedTasks.isNotEmpty) {
                            return customDropdownField(
                              value: assignedTasks.first.id.toString(),
                              items: assignedTasks.map((p) {
                                return DropdownMenuItem(
                                  value: p.id.toString(),
                                  child: Text(p.task),
                                );
                              }).toList(),
                              onChanged: (val) {
                                cubit.selectedTaskId = val ?? '';
                              },
                            );
                          } else {
                            return const Text("No Task for this Employee");
                          }
                        }
                        return const Center(child: Text("No Data"));
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final projectId =
                          int.tryParse(cubit.selectedProjectId ?? '0') ?? 0;
                      final userId =
                          int.tryParse(cubit.selectedUserId ?? '0') ?? 0;
                      context.read<TaskCubit>().getUserTasksForSpecificProjet(
                        projectId,
                        userId,
                      );
                    },
                    icon: Icon(Icons.refresh),
                  ),
                  IconButton(
                    onPressed: () {
                      cubit.selectedTaskId = null;

                      context.read<TaskCubit>().getUserTasksForSpecificProjet(
                        0,
                        0,
                      );
                    },
                    icon: Icon(Icons.cancel, color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "تاريخ البدء",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) cubit.updateStartDate(picked);
                },
                child: AbsorbPointer(
                  child: customTextField(
                    cubit.startDateController,
                    'تاريخ البدء',
                    icon: Icons.date_range,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "تاريخ الانتهاء",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) cubit.updateEndDate(picked);
                },
                child: AbsorbPointer(
                  child: customTextField(
                    cubit.endDateController,
                    'تاريخ الانتهاء',
                    icon: Icons.event,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await context
                        .read<FinancialReportCubit>()
                        .getFinancialReportAdvance(
                          userId: cubit.selectedUserId,
                          projectId: cubit.selectedProjectId,
                          taskId: cubit.selectedTaskId,
                          fromDate: cubit.startDateController.text,
                          toDate: cubit.endDateController.text,
                        );
                  },
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'بحث',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              BlocBuilder<FinancialReportCubit, FinancialReportState>(
                builder: (context, state) {
                  if (state is FinancialLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'جاري تحميل التقرير...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is FinanciaLoaded) {
                    final report = state.report;
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("البيانات العامة: "),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildReportCard(
                                  title: "عدد الساعات",
                                  value: "${report.totalHours}",
                                  icon: Icons.timer,
                                  color: Colors.blueAccent,
                                ),
                                const SizedBox(width: 5),
                                _buildReportCard(
                                  title: "إجمالي التكلفة",
                                  value: "\$${report.totalCost}",
                                  icon: Icons.attach_money,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 5),
                                _buildReportCard(
                                  title: "عدد الإدخالات",
                                  value: "${report.entriesCount}",
                                  icon: Icons.list_alt,
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (cubit.selectedProjectId != null &&
                            cubit.selectedUserId == null) ...[
                          const SizedBox(height: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("بيانات المشروع: "),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const SizedBox(width: 12),
                                  _buildReportCard(
                                    title: "عدد الموظفين",
                                    value:
                                        "${report.projectSummary.usersCount}",
                                    icon: Icons.list_alt,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 12),
                                  _buildReportCard(
                                    title: "عدد المهام",
                                    value:
                                        "${report.projectSummary.tasksCount}",
                                    icon: Icons.list_alt,
                                    color: Colors.orange,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],

                        if (cubit.selectedProjectId == null &&
                            cubit.selectedUserId != null) ...[
                          const SizedBox(height: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("بيانات الموظف: "),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const SizedBox(width: 12),
                                  _buildReportCard(
                                    title: "عدد المشاريع",
                                    value:
                                        "${report.userSummary.projectsCount}",
                                    icon: Icons.list_alt,
                                    color: Colors.pinkAccent,
                                  ),
                                  const SizedBox(width: 12),
                                  _buildReportCard(
                                    title: "عدد المهام",
                                    value: "${report.userSummary.tasksCount}",
                                    icon: Icons.list_alt,
                                    color: Colors.pink,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    );
                  }

                  if (state is FinancialFaliure) {
                    return _buildErrorState(
                      message: 'حدث خطأ: ${state.error}',
                      onRetry: () => context
                          .read<FinancialReportCubit>()
                          .getFinancialReport(),
                    );
                  }

                  return _buildErrorState(
                    message: 'حدث خطأ ما',
                    onRetry: () => context
                        .read<FinancialReportCubit>()
                        .getFinancialReport(),
                  );
                },
              ),
              SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState({
    required String message,
    required VoidCallback onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: ColorManager.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
