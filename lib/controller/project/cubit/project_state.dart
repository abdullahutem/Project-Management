part of 'project_cubit.dart';

@immutable
sealed class ProjectState {}

final class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectLoaded extends ProjectState {
  final List<ProjectsModel> projects;
  ProjectLoaded(this.projects);
}

class SingleProjectLoaded extends ProjectState {
  final SingleProjectModel project;
  SingleProjectLoaded({required this.project});
}

class ProjectsUserLoaded extends ProjectState {
  final List<ProjectsModel> project;

  ProjectsUserLoaded({required this.project});
}

class ProjectError extends ProjectState {
  final String error;
  ProjectError(this.error);
}

class ProjectDeletedSuccess extends ProjectState {}

final class ProjectUpdatedSuccess extends ProjectState {
  final dynamic projectModel;

  ProjectUpdatedSuccess({required this.projectModel});
}

final class AddProjectSuccess extends ProjectState {
  final ProjectsModel newProject;

  AddProjectSuccess({required this.newProject});
}

final class AddProjectLoading extends ProjectState {}

final class AddProjectFailure extends ProjectState {
  final String errormessage;

  AddProjectFailure({required this.errormessage});
}

class ProjectDateUpdated extends ProjectState {}

class ProjectIsActiveChanged extends ProjectState {}
