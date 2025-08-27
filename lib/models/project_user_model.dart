import 'package:cmp/models/task_model.dart';

class ProjectUserModel {
  final int id;
  final int project_id;
  final int user_id;
  final String start_date;
  final String end_date;
  final double cost_per_hour;
  final int min_hours;
  final int max_hours;
  final List<TaskModel> tasks;

  ProjectUserModel({
    required this.id,
    required this.project_id,
    required this.user_id,
    // required this.project_name,
    // required this.user_name,
    required this.start_date,
    required this.end_date,
    required this.cost_per_hour,
    required this.min_hours,
    required this.max_hours,
    required this.tasks,
  });

  factory ProjectUserModel.fromJson(Map<String, dynamic> json) {
    return ProjectUserModel(
      id: json['data']['id'],
      // project_name: json['data']['project_name'],
      // user_name: json['data']['user_name'],
      start_date: json['data']['start_date'],
      end_date: json['data']['end_date'],
      cost_per_hour: (json['data']['cost_per_hour'] as num).toDouble(),
      min_hours: json['data']['min_hours'],
      max_hours: json['data']['max_hours'],
      project_id: json['data']['project_id'],
      user_id: json['data']['user_id'],
      tasks: (json['data']['tasks'] as List)
          .map((item) => TaskModel.fromJsonNoData(item))
          .toList(),
    );
  }
}
