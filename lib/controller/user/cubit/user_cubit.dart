import 'package:cmp/models/login_model.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/repo/user_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepo) : super(UserInitial());
  final UserRepo userRepo;

  //Sign in email
  TextEditingController signInEmail = TextEditingController();
  //Sign in password
  TextEditingController signInPassword = TextEditingController();
  LoginModel? loginModel;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  String selectedRole = 'employee';

  // signInUser() async {
  //   try {
  //     emit(SignInLoading());
  //     final response = await userRepo.siginUser(
  //       signInEmail: signInEmail.text,
  //       signInPassword: signInPassword.text,
  //     );
  //     if (response != null) {
  //       emit(SignInSucsess(message: loginModel!.token));
  //     }
  //   } on ServerException catch (e) {
  //     emit(SignInFaliure(errormessage: e.errorModel.message));
  //   } catch (e) {
  //     emit(SignInFaliure(errormessage: 'Unexpected error: $e'));
  //   }
  // }

  signInUser() async {
    emit(SignInLoading());
    final response = await userRepo.siginUser(
      signInEmail: signInEmail.text,
      signInPassword: signInPassword.text,
    );
    print("=================***********=====${response}");

    response.fold(
      (error) => emit(SignInFaliure(errormessage: error)),
      (loginModel) => emit(SignInSucsess(message: loginModel.token)),
    );
  }

  getAllUsers() async {
    emit(UsersLoading());
    final response = await userRepo.getUsersData();
    print("=================***********=====${response}");

    response.fold(
      (error) => emit(UsersFaliure(errormessage: error)),
      (users) => emit(UsersLoaded(usersList: users)),
    );
  }

  deletelSingleUsers(int id) async {
    emit(UsersLoading());
    final response = await userRepo.deleteSingleUserData(id);
    response.fold((error) => emit(UsersFaliure(errormessage: error)), (
      message,
    ) {
      emit(UserDeletedSuccess());
      getAllUsers();
    });
  }

  // getAllUsers() async {
  //   try {
  //     emit(UsersLoading());
  //     final response = await userRepo.getUsersData();
  //     if (response != null) {
  //       emit(UsersLoaded(usersList: [response]));
  //     }
  //   } on ServerException catch (e) {
  //     emit(UsersFaliure(errormessage: e.errorModel.message));
  //   } catch (e) {
  //     emit(UsersFaliure(errormessage: 'Unexpected error: $e'));
  //   }
  // }
}
