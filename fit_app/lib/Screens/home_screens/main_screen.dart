
import 'package:fit_app/Screens/home_screens/analytics_screen.dart';
import 'package:fit_app/Screens/home_screens/calories_screen.dart';
import 'package:fit_app/Screens/home_screens/distance_screen.dart';
import 'package:fit_app/Screens/home_screens/profile_screen.dart';
import 'package:fit_app/Screens/home_screens/workout_screen.dart';
import 'package:fit_app/widgets/home_widgets/custom_navigationbar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ProfileScreen(),
    const AnalyticsScreen(),
    const WorkoutScreen(),
    const CaloriesScreen(),
    const DistanceScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: SafeArea(child: _screens[_currentIndex]),
      );
   
  }
}
