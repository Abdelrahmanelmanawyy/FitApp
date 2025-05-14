import 'package:fit_app/Screens/auth_screens/sign_in_screen.dart';
import 'package:fit_app/firebase_services/firestore_service.dart';

import 'package:fit_app/firebase_services/storage_service.dart';
import 'package:fit_app/models/workout_models.dart';
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
  final FirestoreService_user _firestoreService = FirestoreService_user();
  final FireStorageService _storageService = FireStorageService();
  final FirestoreService_workout firestoreService = FirestoreService_workout();
  final FirestoreService_Distance firestoreServiceDistance = FirestoreService_Distance();

  String userName = 'Loading...';
  String? _profileImageUrl;
  int stepsNumber = 0;
  bool isLoadingSteps = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadTotalSteps();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await _firestoreService.getUserData();
      final imageUrl = await _storageService.getImageUrl(user.uid);

      setState(() {
        userName = userData?.name ?? 'No Name';
        _profileImageUrl = imageUrl;
      });
    }
  }

  Future<void> _loadTotalSteps() async {
    try {
      int totalDistance = await firestoreServiceDistance.getTotalDistance(); // meters
      const metersPerStep = 0.8;
      final calculatedSteps = (totalDistance / metersPerStep).round();

      setState(() {
        stepsNumber = calculatedSteps;
        isLoadingSteps = false;
      });
    } catch (e) {
      print('Failed to load total steps: $e');
      setState(() {
        stepsNumber = 0;
        isLoadingSteps = false;
      });
    }
  }

  Future<void> _handleImageUpload() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final pickedFile = await _storageService.pickImage();
      if (pickedFile != null) {
        try {
          final imageUrl = await _storageService.uploadImage(pickedFile, user.uid);
          if (imageUrl != null) {
            setState(() {
              _profileImageUrl = imageUrl;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to upload image. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          print('Image upload error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred while uploading the image.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _handleImageUpload,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[200],
                      backgroundImage:
                          _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
                      child: _profileImageUrl == null
                          ? const Icon(Icons.person, size: 40, color: Colors.grey)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userName,
                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder<List<Workout>>(
              stream: firestoreService.getWorkouts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const WorkoutProgressCard(exerciseNumber: 0, exerciseGoal: 50);
                }

                final workouts = snapshot.data!;
                int totalExercises = 0;

                for (final workout in workouts) {
                  totalExercises += workout.exerciseSets.length;
                }

                return WorkoutProgressCard(exerciseNumber: totalExercises, exerciseGoal: 50);
              },
            ),
            const SizedBox(height: 16),
            isLoadingSteps
                ? const CircularProgressIndicator()
                : Activitysteps(stepsNumber: stepsNumber),
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
                    builder: (context) => const SignInScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
