part of 'financial_report_cubit.dart';

@immutable
sealed class FinancialReportState {}

final class FinancialReportInitial extends FinancialReportState {}

final class FinancialLoading extends FinancialReportState {}

final class FinancialSelectedChanged extends FinancialReportState {}

final class SelectTaskChanged extends FinancialReportState {}

final class FinancialDateUpdated extends FinancialReportState {}

final class FinanciaLoaded extends FinancialReportState {
  final FinancialReportModel report;

  FinanciaLoaded({required this.report});
}

final class FinancialFaliure extends FinancialReportState {
  final String error;

  FinancialFaliure({required this.error});
}
