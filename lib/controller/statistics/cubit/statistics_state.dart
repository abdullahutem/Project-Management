part of 'statistics_cubit.dart';

@immutable
sealed class StatisticsState {}

final class StatisticsInitial extends StatisticsState {}

final class ErrorStatistics extends StatisticsState {
  final String error;
  ErrorStatistics({required this.error});
}

final class LoadingStatistics extends StatisticsState {}

final class LoadedStatistics extends StatisticsState {
  final SatisticsModel satisticsModel;
  LoadedStatistics({required this.satisticsModel});
}
