import 'package:cmp/core/api/end_point.dart';

class LoginModel {
  final int id;
  final String token;
  final String role;
  final String name;
  final String email;
  final String phone;
  final String base_salary;

  LoginModel({
    required this.id,
    required this.token,
    required this.role,
    required this.name,
    required this.email,
    required this.phone,
    required this.base_salary,
  });

  factory LoginModel.fromJson(Map<String, dynamic> jsonData) {
    final rawToken = jsonData[ApiKeys.token] as String;
    final cleanToken = rawToken.contains('|')
        ? rawToken.split('|')[1]
        : rawToken;
    return LoginModel(
      token: cleanToken,
      role: jsonData[ApiKeys.role],
      id: jsonData[ApiKeys.id],
      name: jsonData[ApiKeys.name],
      email: jsonData[ApiKeys.email],
      phone: jsonData[ApiKeys.phone],
      base_salary: jsonData[ApiKeys.base_salary],
    );
  }
}
