import 'package:cmp/core/api/end_point.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final double base_salary;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.base_salary,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["data"][ApiKeys.id],
      name: json["data"][ApiKeys.name],
      email: json["data"][ApiKeys.email],
      phone: json["data"][ApiKeys.phone],
      role: json["data"][ApiKeys.role],
      base_salary: double.parse(json["data"][ApiKeys.base_salary].toString()),
    );
  }
}
