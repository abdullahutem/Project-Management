part of 'project_user_cubit.dart';

@immutable
sealed class ProjectUserState {}

final class ProjectUserInitial extends ProjectUserState {}

class ProjectUserLoading extends ProjectUserState {}

class ProjectUserLoaded extends ProjectUserState {
  final List<ProjectUserModel> projectUsers;

  ProjectUserLoaded(this.projectUsers);
}

class ProjectUserError extends ProjectUserState {
  final String message;

  ProjectUserError({required this.message});
}

class ProjectUserDeletedSuccess extends ProjectUserState {}

class ProjectUserUpdatedSuccess extends ProjectUserState {}

class ProjectUserSelectedChanged extends ProjectUserState {}

class AddProjectUserSuccess extends ProjectUserState {
  final ProjectUserModel projectUserModel;

  AddProjectUserSuccess({required this.projectUserModel});
}

class ProjectUserDateUpdated extends ProjectUserState {}
