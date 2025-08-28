import 'package:cmp/models/project_model.dart';

class ProjectsModel {
  final ProjectModel project;
  final int usersCount;
  final int taskPendingCounts;
  final int taskActiveCounts;
  final int taskCompletedCounts;
  final int minHours;
  final int maxHours;
  final double completionPercentage;
  final double currentHours;
  final double minCost;
  final double maxCost;
  final double currentCost;
  final double currentMonthCost;

  ProjectsModel({
    required this.project,
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
  });

  factory ProjectsModel.fromJson(Map<String, dynamic> json) {
    return ProjectsModel(
      project: ProjectModel.fromJsonNoData(json['project']),
      usersCount: json["users_count"] ?? 0,
      taskPendingCounts: json["task_pending_counts"] ?? 0,
      taskActiveCounts: json["task_active_counts"] ?? 0,
      taskCompletedCounts: json["task_completed_counts"] ?? 0,
      minHours: json["min_hours"] ?? 0,
      maxHours: json["max_hours"] ?? 0,
      currentHours: (json["current_hours"] ?? 0).toDouble(),
      minCost: (json["min_cost"] ?? 0).toDouble(),
      maxCost: (json["max_cost"] ?? 0).toDouble(),
      currentCost: (json["current_cost"] ?? 0).toDouble(),
      currentMonthCost: (json["current_month_cost"] ?? 0).toDouble(),
      completionPercentage: (json["completionPercentage"] ?? 0).toDouble(),
    );
  }
  factory ProjectsModel.fromJsonWithData(Map<String, dynamic> json) {
    return ProjectsModel(
      project: ProjectModel.fromJsonNoData(json["data"]['project']),
      usersCount: json["data"]["users_count"] ?? 0,
      taskPendingCounts: json["data"]["task_pending_counts"] ?? 0,
      taskActiveCounts: json["data"]["task_active_counts"] ?? 0,
      taskCompletedCounts: json["data"]["task_completed_counts"] ?? 0,
      minHours: json["data"]["min_hours"] ?? 0,
      maxHours: json["data"]["max_hours"] ?? 0,
      currentHours: (json["data"]["current_hours"] ?? 0).toDouble(),
      minCost: (json["data"]["min_cost"] ?? 0).toDouble(),
      maxCost: (json["data"]["max_cost"] ?? 0).toDouble(),
      currentCost: (json["data"]["current_cost"] ?? 0).toDouble(),
      currentMonthCost: (json["data"]["current_month_cost"] ?? 0).toDouble(),
      completionPercentage: (json["data"]["completionPercentage"] ?? 0)
          .toDouble(),
    );
  }
}
