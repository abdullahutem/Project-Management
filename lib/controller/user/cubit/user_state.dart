part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class SignInSucsess extends UserState {
  final String message;

  SignInSucsess({required this.message});
}

final class SignInLoading extends UserState {}

final class SignInFaliure extends UserState {
  final String errormessage;

  SignInFaliure({required this.errormessage});
}

final class UsersLoading extends UserState {}

final class UsersLoaded extends UserState {
  final List<UserModel> usersList;

  UsersLoaded({required this.usersList});
}

final class UsersFaliure extends UserState {
  final String errormessage;

  UsersFaliure({required this.errormessage});
}

final class SingleUserSucsess extends UserState {}

final class SingleUserLoading extends UserState {}

final class SingleUserFaliure extends UserState {
  final String errormessage;

  SingleUserFaliure({required this.errormessage});
}

final class UserDeletedSuccess extends UserState {}

final class AddUserSucsess extends UserState {
  final UserModel newUser;

  AddUserSucsess({required this.newUser});
}

final class AddUserLoading extends UserState {}

final class AddUserFaliure extends UserState {
  final String errormessage;

  AddUserFaliure({required this.errormessage});
}

final class UsersUpdated extends UserState {
  final UserModel user;
  UsersUpdated({required this.user});
}
