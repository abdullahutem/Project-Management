part of 'task_cubit.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskIsActiveChanged extends TaskState {}

class TaskRepliesDateUpdated extends TaskState {}

class AddTaskLoading extends TaskState {}

class TaskDeletedSuccess extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;

  TaskLoaded({required this.tasks});
}

class AddTaskSuccess extends TaskState {
  final TaskModel tasks;

  AddTaskSuccess({required this.tasks});
}

class AddRepliesTaskSuccess extends TaskState {
  final TaskRepliesModel replies;
  AddRepliesTaskSuccess({required this.replies});
}

class TasksUserLoaded extends TaskState {
  final ProjectUserModel tasks;

  TasksUserLoaded({required this.tasks});
}

class TaskUpdated extends TaskState {
  final TaskModel task;

  TaskUpdated({required this.task});
}

class TaskRepliesUpdated extends TaskState {
  final TaskRepliesModel task;

  TaskRepliesUpdated({required this.task});
}

class SingleTaskLoaded extends TaskState {
  final SingleTaskModel task;

  SingleTaskLoaded({required this.task});
}

class TaskError extends TaskState {
  final String error;
  TaskError(this.error);
}
