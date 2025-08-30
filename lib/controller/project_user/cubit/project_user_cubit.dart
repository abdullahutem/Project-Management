import 'package:bloc/bloc.dart';
import 'package:cmp/models/project_user_model.dart';
import 'package:cmp/repo/project_user_repo.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'project_user_state.dart';

class ProjectUserCubit extends Cubit<ProjectUserState> {
  ProjectUserCubit(this.repository) : super(ProjectUserInitial());
  final ProjectUserRepo repository;
  final formKey = GlobalKey<FormState>();
  TextEditingController userIdController = TextEditingController();
  TextEditingController projectIdController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController costPerHourController = TextEditingController();
  TextEditingController minHoursController = TextEditingController();
  TextEditingController maxHoursController = TextEditingController();

  String? selectedUserId;
  String? selectedProjectId;

  void setSelectedUserId(String? id) {
    selectedUserId = id;
    emit(ProjectUserSelectedChanged());
  }

  void setSelectedProjectId(String? id) {
    selectedProjectId = id;
    emit(ProjectUserSelectedChanged());
  }

  void updateStartDate(DateTime date) {
    startDateController.text = date.toIso8601String().split('T').first;
    emit(ProjectUserDateUpdated());
  }

  void updateEndDate(DateTime date) {
    endDateController.text = date.toIso8601String().split('T').first;
    emit(ProjectUserDateUpdated());
  }

  void getAllProjectUsers() async {
    emit(ProjectUserLoading());
    final result = await repository.getProjectUsersData();
    result.fold(
      (error) => emit(ProjectUserError(message: error)),
      (projects) => emit(ProjectUserLoaded(projects)),
    );
  }

  void deleteSingleProjectUser(int project_id, int user_id) async {
    emit(ProjectUserLoading());
    final response = await repository.deleteSingleProjectUser(
      project_id,
      user_id,
    );
    response.fold((error) => emit(ProjectUserError(message: error)), (message) {
      emit(ProjectUserDeletedSuccess());
      getAllProjectUsers(); // Refresh list
    });
  }

  Future<void> updateSingleProjectUser({
    required String userId,
    required String projectId,
    // required String startDate,
    // required String endDate,
    // required String costPerHour,
    // required String minHours,
    // required String maxHours,
  }) async {
    emit(ProjectUserLoading());
    final response = await repository.updateProjectUser(
      userId: userId,
      projectId: projectId,
      startDate: startDateController.text,
      endDate: endDateController.text,
      costPerHour: costPerHourController.text,
      minHours: minHoursController.text,
      maxHours: maxHoursController.text,
    );
    response.fold((error) => emit(ProjectUserError(message: error)), (data) {
      emit(ProjectUserUpdatedSuccess());
    });
  }

  addNewProjectUser() async {
    emit(ProjectUserLoading());
    final response = await repository.addProjectUser(
      userId: int.parse(selectedUserId!),
      projectId: int.parse(selectedProjectId!),
      startDate: startDateController.text,
      endDate: endDateController.text,
      costPerHour: costPerHourController.text,
      minHours: int.parse(minHoursController.text),
      maxHours: int.parse(maxHoursController.text),
    );

    response.fold(
      (error) => emit(ProjectUserError(message: error)),
      (projectUser) =>
          emit(AddProjectUserSuccess(projectUserModel: projectUser)),
    );
  }

  getSingleProjectUser(int projectid, int userid) async {
    emit(ProjectUserLoading());
    final result = await repository.getSingleProjectUserData(projectid, userid);
    result.fold((error) => emit(ProjectUserError(message: error)), (project) {
      emit(SingleProjectUserLoaded(projectUserModel: project));
      userIdController.text = project.user_id?.toString() ?? '';
      projectIdController.text = project.project_id?.toString() ?? '';
      startDateController.text = project.start_date ?? '';
      endDateController.text = project.end_date ?? '';
      costPerHourController.text = project.cost_per_hour?.toString() ?? '';
      minHoursController.text = project.min_hours?.toString() ?? '';
      maxHoursController.text = project.max_hours?.toString() ?? '';
    });
  }
}
