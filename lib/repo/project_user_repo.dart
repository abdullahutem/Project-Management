import 'package:cmp/core/api/api_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/core/errors/exceptions.dart';
import 'package:cmp/models/project_user_model.dart';
import 'package:dartz/dartz.dart';

class ProjectUserRepo {
  final ApiConsumer api;

  ProjectUserRepo({required this.api});

  // Future<List<ProjectUserModel>> getProjectUsersData() async {
  //   final response = await api.get('project-users');
  //   final List data = response['data'];
  //   return data.map((e) => ProjectUserModel.fromJson(e)).toList();
  // }

  Future<Either<String, List<ProjectUserModel>>> getProjectUsersData() async {
    try {
      final response = await api.get(EndPoint.project_users);
      final List<dynamic> projectListJson = response['data'];
      final List<ProjectUserModel> projectusers = projectListJson
          .map(
            (projectusersJson) =>
                ProjectUserModel.fromJson({'data': projectusersJson}),
          )
          .toList();
      return Right(projectusers);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, dynamic>> deleteSingleProjectUser(
    int project_id,
    int user_id,
  ) async {
    try {
      final response = await api.delete(
        EndPoint.deletProjectUserDataEndPoint(project_id, user_id),
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, dynamic>> updateProjectUser({
    required int id,
    required String userId,
    required String projectId,
    // required String projectName,
    // required String userName,
    // required String costPerHour,
    // required int minHours,
    // required int maxHours,
  }) async {
    try {
      final response = await api.patch(
        EndPoint.getProjectUserDataEndPoint(id),
        data: {
          'user_id': userId,
          'project_id': projectId,
          'user_name': projectId,
          'project_name': projectId,
        },
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, ProjectUserModel>> addProjectUser({
    required int userId,
    required int projectId,
    required String startDate,
    required String endDate,
    required String costPerHour,
    required int minHours,
    required int maxHours,
  }) async {
    try {
      final response = await api.post(
        EndPoint.project_users,
        data: {
          "user_id": userId,
          "project_id": projectId,
          "start_date": startDate,
          "end_date": endDate,
          "cost_per_hour": costPerHour,
          "min_hours": minHours,
          "max_hours": maxHours,
          "created_by": 1,
          "updated_by": 1,
        },
      );
      return Right(ProjectUserModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }
}
