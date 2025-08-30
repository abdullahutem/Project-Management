import 'package:cmp/cache/cache_helper.dart';
import 'package:cmp/core/api/api_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/core/errors/exceptions.dart';
import 'package:cmp/models/logout_model.dart';
import 'package:cmp/models/paginated_users.dart';
import 'package:cmp/models/single_project_model.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/models/login_model.dart';
import 'package:dartz/dartz.dart';

class UserRepo {
  final ApiConsumer api;

  UserRepo({required this.api});

  Future<Either<String, LoginModel>> signInUser({
    required String signInEmail,
    required String signInPassword,
  }) async {
    try {
      final response = await api.post(
        EndPoint.login,
        data: {ApiKeys.email: signInEmail, ApiKeys.password: signInPassword},
      );
      final loginModel = LoginModel.fromJson(response);
      await CacheHelper().saveData(key: ApiKeys.id, value: loginModel.id);
      await CacheHelper().saveData(key: ApiKeys.token, value: loginModel.token);
      await CacheHelper().saveData(key: ApiKeys.role, value: loginModel.role);
      await CacheHelper().saveData(key: ApiKeys.name, value: loginModel.name);
      await CacheHelper().saveData(key: ApiKeys.phone, value: loginModel.phone);
      await CacheHelper().saveData(key: ApiKeys.email, value: loginModel.email);
      await CacheHelper().saveData(
        key: ApiKeys.base_salary,
        value: loginModel.base_salary,
      );
      return Right(loginModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, LogoutModel>> logoutUser() async {
    try {
      final response = await api.post(EndPoint.logout);
      return Right(response);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, List<UserModel>>> getUsersData() async {
    try {
      final response = await api.get(EndPoint.users);
      final List<dynamic> userListJson = response['data'];
      final List<UserModel> users = userListJson
          .map((userJson) => UserModel.fromJson({'data': userJson}))
          .toList();
      return Right(users);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, PaginatedUsers>> getUsersDataPaginated(int page) async {
    try {
      final response = await api.get("${EndPoint.users}?page=$page");

      final List<dynamic> userListJson = response['data'];
      final List<UserModel> users = userListJson
          .map((userJson) => UserModel.fromJson({'data': userJson}))
          .toList();

      final meta = response['meta'];

      return Right(
        PaginatedUsers(
          users: users,
          currentPage: meta['current_page'],
          lastPage: meta['last_page'],
        ),
      );
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, List<UserModel>>> getAllUsersNamesData() async {
    try {
      int currentPage = 1;
      int lastPage = 1;
      List<UserModel> allUsers = [];

      do {
        final response = await api.get("${EndPoint.users}?page=$currentPage");

        final List<dynamic> projectListJson = response['data'];
        final List<UserModel> users = projectListJson
            .map((projectJson) => UserModel.fromJsonNoData(projectJson))
            .toList();

        allUsers.addAll(users);
        lastPage = response['meta']['last_page'];
        currentPage++;
      } while (currentPage <= lastPage);

      return Right(allUsers);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, dynamic>> deleteSingleUserData(int id) async {
    try {
      final response = await api.delete(EndPoint.getUserDataEndPoint(id));
      final dynamic userListJson = response;
      return Right(userListJson);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, UserModel>> addNewUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
    required String base_salary,
  }) async {
    try {
      final response = await api.post(
        EndPoint.users,
        data: {
          ApiKeys.name: name,
          ApiKeys.email: email,
          ApiKeys.password: password,
          ApiKeys.phone: phone,
          ApiKeys.role: role,
          ApiKeys.base_salary: base_salary,
        },
      );
      final userModel = UserModel.fromJson(response);
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, UserModel>> updateUser({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String role,
    required String base_salary,
  }) async {
    try {
      final response = await api.patch(
        EndPoint.updateUserEndPoint(id),
        data: {
          ApiKeys.name: name,
          ApiKeys.email: email,
          ApiKeys.phone: phone,
          ApiKeys.role: role,
          ApiKeys.base_salary: base_salary,
        },
      );
      final userModel = UserModel.fromJson(response);
      return Right(userModel);
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
        response['data'],
      );
      return Right(singleProject);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }
}
