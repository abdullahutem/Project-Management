import 'package:cmp/core/api/api_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/core/errors/exceptions.dart';
import 'package:cmp/models/project_model.dart';
import 'package:cmp/models/projects_of_user_model.dart';
import 'package:cmp/models/single_project_model.dart';
import 'package:dartz/dartz.dart';

class ProjectRepo {
  final ApiConsumer api;
  ProjectRepo({required this.api});

  Future<Either<String, List<ProjectModel>>> getProjectsData() async {
    try {
      final response = await api.get(EndPoint.projects);
      final List<dynamic> projectListJson = response['data'];
      final List<ProjectModel> projects = projectListJson
          .map((projectJson) => ProjectModel.fromJson({'data': projectJson}))
          .toList();
      return Right(projects);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, SingleProjectModel>> getSingleProjectsData(
    int id,
  ) async {
    try {
      final response = await api.get(EndPoint.getSingleProjectDataEndPoint(id));
      final SingleProjectModel singleProject = SingleProjectModel.fromJson(
        response,
      );
      return Right(singleProject);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, dynamic>> deleteSingleProjectData(int id) async {
    try {
      final response = await api.delete(EndPoint.getProjectDataEndPoint(id));
      return Right(response);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, dynamic>> updateProject({
    required int id,
    required String name,
    required String startDate,
    required String endDate,
    required String status,
    required bool is_active,
  }) async {
    try {
      final response = await api.patch(
        EndPoint.getProjectDataEndPoint(id),
        data: {
          'name': name,
          'start_date': startDate,
          'end_date': endDate,
          'status': status,
          "is_active": is_active ? 1 : 0,
        },
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, ProjectModel>> addNewProject({
    required String name,
    required String startDate,
    required String endDate,
    required String status,
    required bool isActive,
  }) async {
    try {
      final response = await api.post(
        EndPoint.projects,
        data: {
          ApiKeys.name: name,
          ApiKeys.startDate: startDate,
          ApiKeys.endDate: endDate,
          ApiKeys.status: status,
          ApiKeys.is_active: isActive,
        },
      );
      final projectModel = ProjectModel.fromJson(response);
      return Right(projectModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, ProjectsOfUserModel>> getPrjectsForSpecificUserData(
    int user_id,
  ) async {
    try {
      final response = await api.get(
        EndPoint.getPrjectForSpecificUserEndPoint(user_id),
      );
      final model = ProjectsOfUserModel.fromJson(response);
      return Right(model);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, ProjectModel>> updateProjectStatus({
    required int id,
    required String status,
    required bool is_active,
  }) async {
    try {
      final response = await api.patch(
        EndPoint.getProjectDataEndPoint(id),
        data: {ApiKeys.status: status, ApiKeys.is_active: is_active},
      );

      final taskModel = ProjectModel.fromJson(response);
      return Right(taskModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }
}
