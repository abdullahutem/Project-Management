import 'package:cmp/cache/cache_helper.dart';
import 'package:cmp/core/api/api_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/core/errors/exceptions.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/models/login_model.dart';
import 'package:dartz/dartz.dart';

class UserRepo {
  final ApiConsumer api;

  UserRepo({required this.api});

  Future<Either<String, LoginModel>> siginUser({
    required String signInEmail,
    required String signInPassword,
  }) async {
    try {
      final response = await api.post(
        EndPoint.login,
        data: {ApiKeys.email: signInEmail, ApiKeys.password: signInPassword},
      );
      final loginModel = LoginModel.fromJson(response);
      print("=================***********=====${loginModel.token}");
      print("=================***********=====${loginModel}");
      await CacheHelper().saveData(key: ApiKeys.token, value: loginModel.token);
      return Right(loginModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, List<UserModel>>> getUsersData() async {
    try {
      final response = await api.get(EndPoint.users);

      // Extract the list of user maps from the "data" key
      final List<dynamic> userListJson = response['data'];

      // Convert each map to a UserModel instance
      final List<UserModel> users = userListJson
          .map((userJson) => UserModel.fromJson({'data': userJson}))
          .toList();

      return Right(users);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, UserModel>> getSingleUserData(int id) async {
    try {
      final response = await api.get(EndPoint.getUserDataEndPoint(id));
      return Right(UserModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  // Future<Either<String, UserModel>> deleteSingleUserData(int id) async {
  //   try {
  //     final response = await api.delete(EndPoint.getUserDataEndPoint(id));
  //     return Right(UserModel.fromJson(response));
  //   } on ServerException catch (e) {
  //     return Left(e.errorModel.message);
  //   }
  // }

  Future<Either<String, dynamic>> deleteSingleUserData(int id) async {
    try {
      final response = await api.delete(EndPoint.getUserDataEndPoint(id));

      print("delete===========================$response");
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
      print("=================***********=====${userModel.id}");
      print("=================***********=====${userModel}");
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }

  Future<Either<String, UserModel>> updateUser({
    required String id,
    required String name,
    required String email,
    required String password,
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
          ApiKeys.password: password,
          ApiKeys.phone: phone,
          ApiKeys.role: role,
          ApiKeys.base_salary: base_salary,
        },
      );
      final userModel = UserModel.fromJson(response);
      print("=================***********=====${userModel.id}");
      print("=================***********=====${userModel}");
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }
}
