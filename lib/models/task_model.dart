import 'package:cmp/core/api/end_point.dart';

class TaskModel {
  final int id;
  final String task;
  final String status;
  final bool is_active;
  final int project_user_id;
  final int? created_by;
  final int? updated_by;
  final int replies_count;
  final double current_cost;

  TaskModel({
    required this.id,
    required this.task,
    required this.status,
    required this.is_active,
    required this.project_user_id,
    required this.created_by,
    required this.updated_by,
    required this.replies_count,
    required this.current_cost,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["data"][ApiKeys.id],
      task: json["data"][ApiKeys.task],
      status: json["data"][ApiKeys.status],
      is_active: json["data"][ApiKeys.is_active],
      project_user_id: json["data"][ApiKeys.project_user_id],
      created_by: json["data"][ApiKeys.created_by],
      updated_by: json["data"][ApiKeys.updated_by],
      replies_count: json["data"][ApiKeys.replies_count],
      current_cost: (json["data"][ApiKeys.current_cost] as num).toDouble(),
    );
  }
  factory TaskModel.fromJsonNoData(Map<String, dynamic> json) {
    return TaskModel(
      id: json[ApiKeys.id],
      task: json[ApiKeys.task],
      status: json[ApiKeys.status],
      is_active: json[ApiKeys.is_active],
      project_user_id: json[ApiKeys.project_user_id],
      created_by: json[ApiKeys.created_by],
      updated_by: json[ApiKeys.updated_by],
      replies_count: json[ApiKeys.replies_count],
      current_cost: (json[ApiKeys.current_cost] as num).toDouble(),
    );
  }
}
