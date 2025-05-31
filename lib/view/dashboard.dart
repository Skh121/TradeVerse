import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 6),
              child: Column(
                children: [
                  Text("Welcome Back, User"),
                  Text(
                    "Dashboard",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            Image.asset("assets/images/dashboardImage.png"),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon:ImageIcon(AssetImage('assets/images/dashboardIcon.png')),label:"Dashboard"),
        BottomNavigationBarItem(icon: ImageIcon(AssetImage('assets/images/performanceIcon.png')),label:"Performance",),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month),label:"Journal"),
        BottomNavigationBarItem(icon: Icon(Icons.person),label:"Profile")
      ]),
    );
  }
}
