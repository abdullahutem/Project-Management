import 'package:bloc/bloc.dart';
import 'package:cmp/models/satistics_model.dart';
import 'package:cmp/repo/statistics_repo.dart';
import 'package:meta/meta.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit(this.repo) : super(StatisticsInitial());
  final StatisticsRepo repo;

  getStatisticsReport() async {
    emit(LoadingStatistics());
    final response = await repo.getStatisticsReport();
    response.fold(
      (error) => emit(ErrorStatistics(error: error)),
      (model) => emit(LoadedStatistics(satisticsModel: model)),
    );
  }
}
