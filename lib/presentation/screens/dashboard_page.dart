import 'package:cmp/presentation/resources/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:cmp/presentation/resources/color_manager.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'لوحة التحكم',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w500,
            fontFamily: "EXPOARABIC",
          ),
        ),
        backgroundColor: ColorManager.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        elevation: 6,
        shadowColor: ColorManager.primaryColor.withOpacity(0.6),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: _buildCardList(),
        ),
      ),
    );
  }

  List<Widget> _buildCardList() {
    return [
      _buildCard('المشاريع', Icons.account_balance_outlined, 'projects'),
      _buildCard('الموظفين', Icons.supervised_user_circle, 'users'),
      _buildCard("التقارير", Icons.more_time_outlined, 'reports'),
    ];
  }

  Widget _buildCard(String text, IconData icon, String route) {
    return InkWell(
      onTap: () {
        _handleCardTap(route);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        color: ColorManager.primaryColor.withOpacity(0.7),
        elevation: 4,
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Container(
                decoration: const BoxDecoration(
                  color: ColorManager.primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25),
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 30,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: "EXPOARABIC",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCardTap(String route) {
    switch (route) {
      case 'users':
        Navigator.pushNamed(context, Routes.usersPage);
        break;
      case 'projects':
        Navigator.pushNamed(context, Routes.projectPage);
        break;
      case 'reports':
        Navigator.pushNamed(context, Routes.usersPage);
        break;
      default:
        // Handle unknown route
        break;
    }
  }
}
