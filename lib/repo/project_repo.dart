import 'package:cmp/core/api/api_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/core/errors/exceptions.dart';
import 'package:cmp/models/paginated_projects.dart';
import 'package:cmp/models/project_model.dart';
import 'package:cmp/models/projects_model.dart';
import 'package:cmp/models/projects_of_user_model.dart';
import 'package:cmp/models/single_project_model.dart';
import 'package:dartz/dartz.dart';

class ProjectRepo {
  final ApiConsumer api;
  ProjectRepo({required this.api});

  Future<Either<String, List<ProjectsModel>>> getProjectsData() async {
    try {
      final response = await api.get(EndPoint.projects);
      final List<dynamic> projectListJson = response['data'];
      final List<ProjectsModel> projects = projectListJson
          .map((projectJson) => ProjectsModel.fromJson(projectJson))
          .toList();

      return Right(projects);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, List<ProjectsModel>>> getAllProjectsNamesData() async {
    try {
      int currentPage = 1;
      int lastPage = 1;
      List<ProjectsModel> allProjects = [];

      do {
        final response = await api.get(
          "${EndPoint.projects}?page=$currentPage",
        );

        final List<dynamic> projectListJson = response['data'];
        final List<ProjectsModel> projects = projectListJson
            .map((projectJson) => ProjectsModel.fromJson(projectJson))
            .toList();

        allProjects.addAll(projects);

        // update pagination info
        lastPage = response['meta']['last_page'];
        currentPage++;
      } while (currentPage <= lastPage);

      return Right(allProjects);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  // Future<Either<String, Map<String, dynamic>>> getProjectsDataPaginated(
  //   int page,
  // ) async {
  //   try {
  //     final response = await api.get("${EndPoint.projects}?page=$page");

  //     final List<dynamic> data = response['data'];
  //     final projects = data
  //         .map((projectJson) => ProjectsModel.fromJson(projectJson))
  //         .toList();

  //     return Right({
  //       "projects": projects,
  //       "current_page": response['current_page'],
  //       "last_page": response['last_page'],
  //     });
  //   } on ServerException catch (e) {
  //     return Left(e.errorModel.message);
  //   }
  // }
  Future<Either<String, PaginatedProjects>> getProjectsDataPaginated(
    int page,
  ) async {
    try {
      final response = await api.get("${EndPoint.projects}?page=$page");
      final List<dynamic> projectsListJson = response['data'];
      final List<ProjectsModel> projects = projectsListJson
          .map((projectsJson) => ProjectsModel.fromJson(projectsJson))
          .toList();

      final meta = response['meta'];

      return Right(
        PaginatedProjects(
          projects: projects,
          currentPage: meta['current_page'],
          lastPage: meta['last_page'],
        ),
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  // Future<Either<String, PafinatedProjects>> getProjectsDataPaginated(
  //   int page,
  // ) async {
  //   try {
  //     final response = await api.get("${EndPoint.projects}?page=$page");
  //     final List<dynamic> projectListJson = response;
  //     final List<ProjectsModel> projects = projectListJson
  //         .map((userJson) => ProjectsModel.fromJson({'data': userJson}))
  //         .toList();
  //     final meta = response['meta'];
  //     return Right(
  //       PafinatedProjects(
  //         projects: projects,
  //         currentPage: meta['current_page'],
  //         lastPage: meta['last_page'],
  //       ),
  //     );
  //   } on ServerException catch (e) {
  //     return Left(e.errorModel.message);
  //   }
  // }

  Future<Either<String, SingleProjectModel>> getSingleProjectsData(
    int id,
  ) async {
    try {
      final response = await api.get(EndPoint.getSingleProjectDataEndPoint(id));
      final SingleProjectModel singleProject = SingleProjectModel.fromJson(
        response['data'],
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

  Future<Either<String, ProjectsModel>> addNewProject({
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
      final projectModel = ProjectsModel.fromJson(response['data']);
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

  //dd
  Future<Either<String, ProjectsModel>> updateProjectStatus({
    required int id,
    required String status,
    required bool is_active,
  }) async {
    try {
      final response = await api.patch(
        EndPoint.getProjectDataEndPoint(id),
        data: {ApiKeys.status: status, ApiKeys.is_active: is_active},
      );

      final taskModel = ProjectsModel.fromJson(response['data']);
      return Right(taskModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }
}
