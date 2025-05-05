import 'package:fit_app/Screens/auth_screens/sign_in_screen.dart';
import 'package:fit_app/firebase_services/firestore_service.dart';
import 'package:fit_app/widgets/home_widgets/profile_screen_widgets/activitysteps.dart';
import 'package:fit_app/widgets/home_widgets/profile_screen_widgets/profileobstions.dart';
import 'package:fit_app/widgets/home_widgets/profile_screen_widgets/workoutprogress_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Loading...';
  final FirestoreService_user _firestoreService = FirestoreService_user();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _firestoreService.getUserData();
    if (userData != null) {
      setState(() {
        userName = userData.name ?? 'No Name';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {},
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              WorkoutProgressCard(),
              const SizedBox(height: 16),
              Activitysteps(),
              const SizedBox(height: 24),
              MenuOption(
                icon: Icons.info_outline,
                title: 'About app',
                color: Colors.blue,
                onTap: () {},
              ),
              MenuOption(
                icon: Icons.settings_outlined,
                title: 'Settings',
                color: Colors.blue,
                onTap: () {},
              ),
              MenuOption(
                icon: Icons.logout,
                title: 'Logout',
                color: Colors.red,
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
