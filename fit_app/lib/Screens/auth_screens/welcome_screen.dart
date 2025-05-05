import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_app/Screens/auth_screens/sign_in_screen.dart';
import 'package:fit_app/Screens/auth_screens/sign_up_screen.dart';
import 'package:fit_app/Screens/home_screens/main_screen.dart';
import 'package:fit_app/constants/color.dart';
import 'package:fit_app/widgets/auth_widgets/custom_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
    _checkIfUserIsLoggedIn();
  }

  void _checkIfUserIsLoggedIn() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppGradients.primaryGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                const SizedBox(height: 60),
                Container(
                  width: 150,
                  height: 150,
                  child: Image.asset('images/app-icon.png'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 15),
                    Transform.scale(
                      scale: 1.3,
                      child: Image.asset(
                        'images/hand_left.png',
                        width: 110,
                        height: 110,
                      ),
                    ),
                    const Text(
                      'TrackFit',
                      style: TextStyle(color: Colors.white, fontSize: 35),
                    ),
                    Transform.scale(
                      scale: 1.3,
                      child: Image.asset(
                        'images/hand_right.png',
                        width: 110,
                        height: 110,
                      ),
                    ),
                    const SizedBox(width: 15),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const Text(
                      'Welcome',
                      style: TextStyle(color: Colors.white, fontSize: 45),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Sign In',
                      backgroundGradient: AppGradients.primaryGradient,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: 'Sign Up',
                      backgroundColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      textColor: Colors.black,
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'continue with',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset('images/logo_facebook.png'),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset('images/logo_google.png'),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {},
                          icon: Image.asset('images/logo_apple.png'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
