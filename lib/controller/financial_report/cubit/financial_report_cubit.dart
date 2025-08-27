import 'package:bloc/bloc.dart';
import 'package:cmp/models/financial_report_model.dart';
import 'package:cmp/repo/financial_report_repo.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'financial_report_state.dart';

class FinancialReportCubit extends Cubit<FinancialReportState> {
  FinancialReportCubit(this.repo) : super(FinancialReportInitial());
  final FinancialReportRepo repo;
  TextEditingController userIdController = TextEditingController();
  TextEditingController projectIdController = TextEditingController();
  TextEditingController taskIdController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  String? selectedUserId;
  String? selectedProjectId;
  String? selectedTaskId;
  bool selectTask = false;

  void setselectTask(bool value) {
    selectTask = value;
    emit(SelectTaskChanged());
  }

  void setSelectedUserId(String? id) {
    selectedUserId = id;
    emit(FinancialSelectedChanged());
  }

  void setSelectedProjectId(String? id) {
    selectedProjectId = id;
    emit(FinancialSelectedChanged());
  }

  void setSelectedTaskId(String? id) {
    selectedTaskId = id;
    emit(FinancialSelectedChanged());
  }

  void updateStartDate(DateTime date) {
    startDateController.text = date.toIso8601String().split('T').first;
    emit(FinancialDateUpdated());
  }

  void updateEndDate(DateTime date) {
    endDateController.text = date.toIso8601String().split('T').first;
    emit(FinancialDateUpdated());
  }

  getFinancialReport() async {
    emit(FinancialLoading());
    final response = await repo.getFinancialReportData();
    response.fold(
      (error) => emit(FinancialFaliure(error: error)),
      (report) => emit(FinanciaLoaded(report: report)),
    );
  }

  getFinancialReportAdvance({
    String? userId,
    String? projectId,
    String? taskId,
    String? fromDate,
    String? toDate,
  }) async {
    emit(FinancialLoading());
    final response = await repo.getFinancialReportData(
      projectId: projectId,
      userId: userId,
      taskId: taskId,
      fromDate: fromDate,
      toDate: toDate,
    );
    response.fold(
      (error) => emit(FinancialFaliure(error: error)),
      (report) => emit(FinanciaLoaded(report: report)),
    );
  }
}
