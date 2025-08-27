import 'package:cmp/core/api/api_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/core/errors/exceptions.dart';
import 'package:cmp/models/project_user_model.dart';
import 'package:cmp/models/single_task_model.dart';
import 'package:cmp/models/task_model.dart';
import 'package:cmp/models/task_replies_model.dart';
import 'package:dartz/dartz.dart';

class TaskRepo {
  final ApiConsumer api;

  TaskRepo({required this.api});

  Future<Either<String, List<TaskModel>>> getTasksData(int id) async {
    try {
      final response = await api.get(EndPoint.getTaskEndPoint(id));
      final List<dynamic> tasksListJson = response['data'];
      final List<TaskModel> tasks = tasksListJson
          .map((projectJson) => TaskModel.fromJson({'data': projectJson}))
          .toList();
      return Right(tasks);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, ProjectUserModel>> getTasksUserInSpecificProjectData(
    int project_id,
    int user_id,
  ) async {
    try {
      final response = await api.get(
        EndPoint.getUserTaskInSpecificProjectEndPoint(project_id, user_id),
      );
      final model = ProjectUserModel.fromJson(response);
      return Right(model);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, SingleTaskModel>> getSingleTaskData(int task_id) async {
    try {
      final response = await api.get(EndPoint.getSingleTaskEndPoint(task_id));
      final model = SingleTaskModel.fromJson(response);
      return Right(model);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, TaskModel>> addNewTask({
    required String task,
    required String project_user_id,
    required String status,
    required bool isActive,
  }) async {
    try {
      final response = await api.post(
        EndPoint.task,
        data: {
          ApiKeys.task: task,
          ApiKeys.project_user_id: project_user_id,
          ApiKeys.status: status,
          ApiKeys.is_active: isActive,
        },
      );
      final taskModel = TaskModel.fromJson(response);
      return Right(taskModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, dynamic>> deleteTaskData(int id) async {
    try {
      final response = await api.delete(EndPoint.deleteTaskEndPoint(id));
      final dynamic task = response;
      return Right(task);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, TaskModel>> updateTask({
    required String id,
    required String task,
    required String status,
    required bool isActive,
    required String projectUserId,
  }) async {
    try {
      final response = await api.patch(
        EndPoint.updateTaskEndPoint(id),
        data: {
          ApiKeys.task: task,
          ApiKeys.status: status,
          ApiKeys.is_active: isActive,
          ApiKeys.project_user_id: projectUserId,
        },
      );

      final taskModel = TaskModel.fromJson(response);
      return Right(taskModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, TaskModel>> updateTaskStatus({
    required String id,
    required String status,
    required bool is_active,
  }) async {
    try {
      final response = await api.patch(
        EndPoint.updateTaskEndPoint(id),
        data: {ApiKeys.status: status, ApiKeys.is_active: is_active},
      );

      final taskModel = TaskModel.fromJson(response);
      return Right(taskModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, TaskRepliesModel>> updateTaskRepliesStatus({
    required int id,
    required String status,
  }) async {
    try {
      final response = await api.patch(
        EndPoint.updateTaskRepliesEndPoint(id),
        data: {ApiKeys.status: status},
      );
      final taskModel = TaskRepliesModel.fromJsonWithData(response);
      return Right(taskModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, TaskRepliesModel>> addTaskReplies({
    required String note,
    required String status,
    required String task_id,
    required String start_date,
    required String end_date,
  }) async {
    try {
      final response = await api.post(
        EndPoint.task_replies,
        data: {
          ApiKeys.note: note,
          ApiKeys.status: status,
          ApiKeys.task_id: task_id,
          ApiKeys.startDate: start_date,
          ApiKeys.endDate: end_date,
        },
      );
      final taskReplies = TaskRepliesModel.fromJsonWithData(response);
      return Right(taskReplies);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }
}
