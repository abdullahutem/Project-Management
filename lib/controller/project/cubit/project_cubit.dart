import 'package:bloc/bloc.dart';
import 'package:cmp/models/project_model.dart';
import 'package:cmp/models/projects_model.dart';
import 'package:cmp/models/projects_of_user_model.dart';
import 'package:cmp/models/single_project_model.dart';
import 'package:cmp/repo/project_repo.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  final ProjectRepo projectRepo;
  TextEditingController idController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  //TextEditingController isActiveController = TextEditingController();
  bool? isActive;
  bool isUpdateValue = true;
  ProjectCubit(this.projectRepo) : super(ProjectInitial());
  final formKey = GlobalKey<FormState>();
  List<ProjectModel> projectList = [];
  List<ProjectsModel> projectsList = [];

  void updateStartDate(DateTime date) {
    startDateController.text = date.toIso8601String().split('T').first;
    emit(ProjectDateUpdated());
  }

  void updateEndDate(DateTime date) {
    endDateController.text = date.toIso8601String().split('T').first;
    emit(ProjectDateUpdated());
  }

  void updateIsActive(bool value) {
    isActive = value;
    emit(ProjectIsActiveChanged());
  }

  void updateValue(bool value) {
    isUpdateValue = value;
    emit(ProjectIsActiveChanged());
  }

  getAllProjects() async {
    emit(ProjectLoading());
    final result = await projectRepo.getProjectsData();
    result.fold((error) => emit(ProjectError(error)), (projects) {
      projectsList = projects;
      emit(ProjectLoaded(projects));
    });
  }

  getSingleProjects(int id) async {
    emit(ProjectLoading());
    final result = await projectRepo.getSingleProjectsData(id);
    result.fold((error) => emit(ProjectError(error)), (project) {
      emit(SingleProjectLoaded(project: project));
    });
  }

  getPrjectsForSpecificUser(int id) async {
    emit(ProjectLoading());
    final result = await projectRepo.getPrjectsForSpecificUserData(id);
    result.fold(
      (error) => emit(ProjectError(error)),
      (project) => emit(ProjectsUserLoaded(project: project)),
    );
  }

  deleteSingleProject(int id) async {
    emit(ProjectLoading());
    final response = await projectRepo.deleteSingleProjectData(id);
    response.fold((error) => emit(ProjectError(error)), (message) {
      emit(ProjectDeletedSuccess());
      getAllProjects();
    });
  }

  Future<void> updateSingleProject(int id) async {
    emit(ProjectLoading());
    final response = await projectRepo.updateProject(
      id: id,
      name: nameController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      status: statusController.text,
      is_active: isActive!,
    );
    response.fold((error) => emit(ProjectError(error)), (project) {
      emit(ProjectUpdatedSuccess(projectModel: project));
      getAllProjects();
    });
  }

  addNewProject() async {
    emit(AddProjectLoading());
    final response = await projectRepo.addNewProject(
      name: nameController.text,
      startDate: startDateController.text,
      endDate: endDateController.text,
      status: statusController.text,
      isActive: isUpdateValue,
    );
    response.fold(
      (error) => emit(AddProjectFailure(errormessage: error)),
      (newProject) => emit(AddProjectSuccess(newProject: newProject)),
    );
  }

  updateTaskStatus(int id, String status, bool is_active) async {
    emit(ProjectLoading());
    final response = await projectRepo.updateProjectStatus(
      id: id,
      status: status,
      is_active: is_active,
    );
    response.fold((error) => emit(ProjectError(error)), (message) {
      emit(ProjectUpdatedSuccess(projectModel: message));
    });
  }
}
