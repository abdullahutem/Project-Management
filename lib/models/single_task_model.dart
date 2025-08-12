import 'package:cmp/models/task_model.dart';
import 'package:cmp/models/task_replies_model.dart';

class SingleTaskModel {
  final TaskModel task;
  final String user_name;
  final String project_name;
  final int replies_count;
  final num cost;
  final List<TaskRepliesModel> replies;

  SingleTaskModel({
    required this.task,
    required this.user_name,
    required this.project_name,
    required this.replies_count,
    required this.cost,
    required this.replies,
  });

  factory SingleTaskModel.fromJson(Map<String, dynamic> json) {
    return SingleTaskModel(
      task: TaskModel.fromJsonNoData(json['task']),
      user_name: json['user_name'] as String,
      project_name: json['project_name'] as String,
      replies_count: json['replies_count'] as int,
      cost: json['cost'] as num,
      replies: (json['replies'] as List<dynamic>)
          .map((reply) => TaskRepliesModel.fromJson(reply))
          .toList(),
    );
  }
}
