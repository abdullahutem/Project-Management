import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/core/errors/errors_model.dart';

class ErrorModel {
  final String message;
  final ErrorsModel? errors;

  ErrorModel({required this.message, this.errors});

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    return ErrorModel(
      message: jsonData[ApiKeys.message] ?? 'Unknown error',
      errors: jsonData[ApiKeys.errors] is Map<String, dynamic>
          ? ErrorsModel.fromJson(jsonData[ApiKeys.errors])
          : null,
    );
  }
}
