import 'package:cmp/core/api/end_point.dart';

class LoginModel {
  final String token;

  LoginModel({required this.token});

  factory LoginModel.fromJson(Map<String, dynamic> jsonData) {
    final rawToken = jsonData[ApiKeys.token] as String;
    final cleanToken = rawToken.contains('|')
        ? rawToken.split('|')[1]
        : rawToken;
    return LoginModel(token: cleanToken);
  }
}
