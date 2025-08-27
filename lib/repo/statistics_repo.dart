import 'package:cmp/core/api/api_consumer.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/core/errors/exceptions.dart';
import 'package:cmp/models/satistics_model.dart';
import 'package:dartz/dartz.dart';

class StatisticsRepo {
  final ApiConsumer api;

  StatisticsRepo({required this.api});

  Future<Either<String, SatisticsModel>> getStatisticsReport() async {
    try {
      final response = await api.get(EndPoint.stats);
      final model = SatisticsModel.fromJson(response);
      return Right(model);
    } on ServerException catch (e) {
      return Left(e.errorModel.message);
    }
  }
}
