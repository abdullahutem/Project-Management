import 'package:cmp/core/api/end_point.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final double base_salary;
  final int projects_count;
  final int task_pending_counts;
  final int task_active_counts;
  final int task_completed_counts;
  final double total_hours;
  final double total_cost;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.base_salary,
    required this.projects_count,
    required this.task_pending_counts,
    required this.task_active_counts,
    required this.task_completed_counts,
    required this.total_hours,
    required this.total_cost,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["data"][ApiKeys.id],
      name: json["data"][ApiKeys.name],
      email: json["data"][ApiKeys.email],
      phone: json["data"][ApiKeys.phone],
      role: json["data"][ApiKeys.role],
      base_salary: double.parse(json["data"][ApiKeys.base_salary].toString()),
      projects_count: json["data"][ApiKeys.projects_count],
      task_pending_counts: json["data"][ApiKeys.task_pending_counts],
      task_active_counts: json["data"][ApiKeys.task_active_counts],
      task_completed_counts: json["data"][ApiKeys.task_completed_counts],
      total_hours: (json["data"][ApiKeys.total_hours] as num).toDouble(),
      total_cost: (json["data"][ApiKeys.total_cost] as num).toDouble(),
    );
  }
  factory UserModel.fromJsonNoData(Map<String, dynamic> json) {
    return UserModel(
      id: json[ApiKeys.id],
      name: json[ApiKeys.name],
      email: json[ApiKeys.email],
      phone: json[ApiKeys.phone],
      role: json[ApiKeys.role],
      base_salary: double.parse(json[ApiKeys.base_salary].toString()),
      projects_count: json[ApiKeys.projects_count],
      task_pending_counts: json[ApiKeys.task_pending_counts],
      task_active_counts: json[ApiKeys.task_active_counts],
      task_completed_counts: json[ApiKeys.task_completed_counts],
      total_hours: (json[ApiKeys.total_hours] as num).toDouble(),
      total_cost: (json[ApiKeys.total_cost] as num).toDouble(),
    );
  }
}
