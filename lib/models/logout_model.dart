import 'package:cmp/core/api/end_point.dart';

class LogoutModel {
  final String message;

  LogoutModel({required this.message});
  factory LogoutModel.fromJson(Map<String, dynamic> jsonData) {
    return LogoutModel(message: jsonData[ApiKeys.message]);
  }
}
