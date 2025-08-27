import 'package:cmp/core/api/api_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/core/errors/exceptions.dart';
import 'package:cmp/models/projects_of_user_model.dart';
import 'package:dartz/dartz.dart';

class EmployeeRepo {
  final ApiConsumer api;

  EmployeeRepo({required this.api});

  Future<Either<String, ProjectsOfUserModel>> getTasksUserInSpecificProjectData(
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
}
