import 'package:cmp/core/api/end_point.dart';

class TaskRepliesModel {
  // "id": 72,
  //           "note": "Quia impedit accusamus debitis ut maxime.",
  //           "task_id": 53,
  //           "start_date": "2025-07-15 06:55:32",
  //           "end_date": "2025-07-15 07:01:32",
  //           "status": "Approved"

  final int id;
  final String note;
  final int task_id;
  final String start_date;
  final String end_date;
  final String status;

  TaskRepliesModel({
    required this.id,
    required this.note,
    required this.task_id,
    required this.start_date,
    required this.end_date,
    required this.status,
  });

  factory TaskRepliesModel.fromJson(Map<String, dynamic> json) {
    return TaskRepliesModel(
      id: json[ApiKeys.id],
      note: json[ApiKeys.note],
      task_id: json[ApiKeys.task_id],
      start_date: json[ApiKeys.startDate],
      end_date: json[ApiKeys.endDate],
      status: json[ApiKeys.status],
    );
  }

  factory TaskRepliesModel.fromJsonWithData(Map<String, dynamic> json) {
    return TaskRepliesModel(
      id: json["data"][ApiKeys.id],
      note: json["data"][ApiKeys.note],
      task_id: json["data"][ApiKeys.task_id],
      start_date: json["data"][ApiKeys.startDate],
      end_date: json["data"][ApiKeys.endDate],
      status: json["data"][ApiKeys.status],
    );
  }
}
