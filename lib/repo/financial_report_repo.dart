import 'package:cmp/core/api/api_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/core/errors/exceptions.dart';
import 'package:cmp/models/financial_report_model.dart';

import 'package:dartz/dartz.dart';

class FinancialReportRepo {
  final ApiConsumer api;

  FinancialReportRepo({required this.api});

  // Future<Either<String, FinancialReportModel>> getFinancialReportData() async {
  //   try {
  //     final response = await api.get(EndPoint.financial_report);
  //     final FinancialReportModel report = FinancialReportModel.fromJson(
  //       response,
  //     );
  //     return Right(report);
  //   } on ServerException catch (e) {
  //     return Left(e.errorModel.message);
  //   }
  // }

  Future<Either<String, FinancialReportModel>> getFinancialReportData({
    String? userId,
    String? projectId,
    String? taskId,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      final response = await api.get(
        EndPoint.financial_report,
        queryParameters: {
          'user_id': userId,
          'project_id': projectId,
          'task_id': taskId,
          'from': fromDate,
          'to': toDate,
        },
      );
      final FinancialReportModel report = FinancialReportModel.fromJson(
        response,
      );
      return Right(report);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }
}
