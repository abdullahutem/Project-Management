import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/models/user_model.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:cmp/presentation/screens/users/edit_users_page.dart';
import 'package:cmp/presentation/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersDashbordPage extends StatelessWidget {
  const UsersDashbordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UsersFaliure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errormessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        } else if (state is UserDeletedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم حذف الموظف"),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorManager.primaryColor,
            title: const Text(
              'الموظفين',
              style: TextStyle(
                fontFamily: "EXPOARABIC",
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Builder(
            builder: (_) {
              if (state is UsersLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is UsersLoaded) {
                final List<UserModel> employees = state.usersList;
                if (employees.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا توجد بيانات',
                      style: TextStyle(
                        fontFamily: "EXPOARABIC",
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: employees.length,
                      // In UsersDashbordPage, inside ListView.builder's itemBuilder:
                      itemBuilder: (context, index) {
                        final user = employees[index];
                        return UserCard(
                          user: user,
                          onEdit: () async {
                            // This is your existing edit logic
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditUsersPage(
                                  name: user.name,
                                  email: user.email,
                                  phone: user.phone,
                                  id: user.id.toString(),
                                  salary: user.base_salary.toString(),
                                  role: user.role,
                                ),
                              ),
                            );
                            if (result == true) {
                              context.read<UserCubit>().getAllUsers();
                            }
                          },
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("حذف"),
                                content: const Text(
                                  "هل تريد حقا حذف المستخدم؟",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text("إلغاء"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                      context
                                          .read<UserCubit>()
                                          .deletelSingleUsers(user.id);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                      foregroundColor: Theme.of(
                                        context,
                                      ).colorScheme.onError,
                                    ),
                                    child: const Text("حذف"),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                }
              } else if (state is UsersFaliure) {
                return Center(
                  child: Text(
                    'حدث خطأ: ${state.errormessage}',
                    style: const TextStyle(
                      fontFamily: "EXPOARABIC",
                      color: Colors.redAccent,
                      fontSize: 16,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                Routes.addUsersPage,
              );
              if (result == true) {
                context.read<UserCubit>().getAllUsers();
              }
            },
            icon: const Icon(Icons.person_add, color: Colors.white),
            label: const Text(
              'أضف موظف',
              style: TextStyle(fontFamily: "EXPOARABIC", color: Colors.white),
            ),
            backgroundColor: ColorManager.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
