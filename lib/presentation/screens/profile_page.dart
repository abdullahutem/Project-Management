import 'package:cmp/cache/cache_helper.dart';
import 'package:cmp/controller/user/cubit/user_cubit.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- DUMMY DATA ---
    // You can replace this with real data from your application.
    String? userName = CacheHelper().getDataString(key: ApiKeys.name);
    String? userRole = CacheHelper().getDataString(key: ApiKeys.role);
    String? userPhoneNumber = CacheHelper().getDataString(key: ApiKeys.phone);
    String? baseSalary = CacheHelper().getDataString(key: ApiKeys.base_salary);
    String profilePictureUrl =
        'https://placehold.co/150x150/000000/FFFFFF/png?text=${userName?[0]}';

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorManager.primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: 16.0,
              ),
              decoration: const BoxDecoration(
                color: ColorManager.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 70.0,
                    backgroundImage: NetworkImage(profilePictureUrl),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 16.0),
                  // User's Name
                  Text(
                    userName!,
                    style: const TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // User's Role
                  Text(
                    userRole!,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20.0),

            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    // Phone Number
                    ListTile(
                      leading: const Icon(
                        Icons.phone,
                        color: ColorManager.primaryColor,
                      ),
                      title: const Text(
                        'رقم الجوال',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        userPhoneNumber!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Divider(height: 20.0, color: Colors.grey),
                    ListTile(
                      leading: const Icon(
                        Icons.attach_money,
                        color: ColorManager.primaryColor,
                      ),
                      title: const Text(
                        'الراتب الأساسي',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        baseSalary!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  context.read<UserCubit>().logoutUser();
                  logoutUser(context);
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 28,
                ),
                label: const Text(
                  "تسجيل الخروج",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void logoutUser(BuildContext context) {
  // Remove the token from SharedPreferences
  CacheHelper().removeData(key: ApiKeys.token);

  // Navigate to the login screen and remove all previous routes
  Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
}
