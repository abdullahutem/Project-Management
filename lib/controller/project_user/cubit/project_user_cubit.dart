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

  void deleteSingleProjectUser(int id) async {
    emit(ProjectUserLoading());
    final response = await repository.deleteSingleProjectUser(id);
    response.fold((error) => emit(ProjectUserError(message: error)), (message) {
      emit(ProjectUserDeletedSuccess());
      getAllProjectUsers(); // Refresh list
    });
  }

  Future<void> updateSingleProjectUser(int id) async {
    emit(ProjectUserLoading());
    final response = await repository.updateProjectUser(
      id: id,
      userId: selectedUserId.toString(),
      projectId: selectedProjectId.toString(),
      // projectName: projectNameController.text,
      // userName: userNameController.text,
      // startDate: startDateController.text,
      // endDate: endDateController.text,
      // costPerHour: costPerHourController.text,
      // minHours: int.parse(minHoursController.text),
      // maxHours: int.parse(maxHoursController.text),
    );

    response.fold((error) => emit(ProjectUserError(message: error)), (data) {
      emit(ProjectUserUpdatedSuccess());
      getAllProjectUsers();
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
      user_name: userNameController.text,
      project_name: projectNameController.text,
    );

    response.fold(
      (error) => emit(ProjectUserError(message: error)),
      (projectUser) =>
          emit(AddProjectUserSuccess(projectUserModel: projectUser)),
    );
  }
}
