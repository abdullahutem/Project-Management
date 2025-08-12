import 'package:cmp/cache/cache_helper.dart';
import 'package:cmp/core/api/end_point.dart';
import 'package:cmp/presentation/resources/color_manager.dart';
import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UserSideMenu extends StatelessWidget {
  const UserSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorManager.primaryColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Container(
              color: ColorManager.white,
              child: Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 120,
                  width: 120,
                ),
              ),
            ),
          ),
          DrawerListTile(
            title: "لوحة التحكم",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.userdashboardPage,
                (route) => false,
              );
            },
          ),
          DrawerListTile(
            title: "مشاريعي",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              // Navigator.pushNamed(context, Routes.projectPage);
            },
          ),

          DrawerListTile(
            title: "مهامي",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              Navigator.pushNamed(context, Routes.allProjects);
            },
          ),

          DrawerListTile(
            title: "التقارير",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {},
          ),

          DrawerListTile(
            title: "تسجيل الخروج",
            svgSrc: "assets/icons/logout.svg",
            press: () {
              logoutUser(context);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 20.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        height: 26,
      ),
      title: Text(
        title,
        style: TextStyle(color: ColorManager.white, fontSize: 20),
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
