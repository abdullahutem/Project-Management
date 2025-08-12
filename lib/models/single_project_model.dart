import 'package:cmp/models/project_model.dart';
import 'package:cmp/models/user_model.dart';

class SingleProjectModel {
  final ProjectModel projectModel;
  final int usersCount;
  final int taskPendingCounts;
  final int taskActiveCounts;
  final int taskCompletedCounts;
  final double minHours;
  final double maxHours;
  final double currentHours;
  final double minCost;
  final double maxCost;
  final double currentCost;
  final double currentMonthCost;
  final double completionPercentage;
  final List<UserModel> users;

  SingleProjectModel({
    required this.projectModel,
    required this.usersCount,
    required this.taskPendingCounts,
    required this.taskActiveCounts,
    required this.taskCompletedCounts,
    required this.minHours,
    required this.maxHours,
    required this.currentHours,
    required this.minCost,
    required this.maxCost,
    required this.currentCost,
    required this.currentMonthCost,
    required this.completionPercentage,
    required this.users,
  });

  factory SingleProjectModel.fromJson(Map<String, dynamic> json) {
    return SingleProjectModel(
      projectModel: ProjectModel.fromJsonNoData(json['project']),
      usersCount: json['users_count'] ?? 0,
      taskPendingCounts: json['task_pending_counts'] ?? 0,
      taskActiveCounts: json['task_active_counts'] ?? 0,
      taskCompletedCounts: json['task_completed_counts'] ?? 0,
      minHours: (json['min_hours'] ?? 0).toDouble(),
      maxHours: (json['max_hours'] ?? 0).toDouble(),
      currentHours: (json['current_hours'] ?? 0).toDouble(),
      minCost: (json['min_cost'] ?? 0).toDouble(),
      maxCost: (json['max_cost'] ?? 0).toDouble(),
      currentCost: (json['current_cost'] ?? 0).toDouble(),
      currentMonthCost: (json['current_month_cost'] ?? 0).toDouble(),
      completionPercentage: (json['completionPercentage'] ?? 0).toDouble(),
      users: (json['users'] as List<dynamic>? ?? [])
          .map((u) => UserModel.fromJsonNoData(u))
          .toList(),
    );
  }
}
