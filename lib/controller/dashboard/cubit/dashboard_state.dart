part of 'dashboard_cubit.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoading extends DashboardState {}

final class DashboardLoaded extends DashboardState {}

final class DashboardError extends DashboardState {
  final String errormessage;

  DashboardError({required this.errormessage});
}
