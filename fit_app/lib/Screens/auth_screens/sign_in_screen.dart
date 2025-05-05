
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_app/Screens/auth_screens/sign_up_screen.dart';
import 'package:fit_app/Screens/home_screens/main_screen.dart';
import 'package:fit_app/constants/color.dart';
import 'package:fit_app/firebase_services/auth_service.dart';
import 'package:fit_app/widgets/auth_widgets/custom_button.dart';
import 'package:fit_app/widgets/auth_widgets/custom_textfiled.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;



  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        User? user = await _auth.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(), 
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error signing in: ${e.toString()}")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,  
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppGradients.primaryGradient
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 80,left: 50),
              child: Column(
                children: [
                  Text('Hello ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold
                  ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 7,left: 50),
              child: Text('Sign In ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),
              ),
            ),
            SizedBox(height: 40,),
            Container(
              width: 500,
              height: 550,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, left: 50, right: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,   
                        children: [
                          SizedBox(height: 30,),
                          CustomTextFiled(
                            controller: _emailController,
                
                            label: 'Email',
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30,),
                          CustomTextFiled(
                            controller: _passwordController,
                            hintText: '',
                            label: 'Password',
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                
                    Padding(
                      padding: const EdgeInsets.only(left: 230, top: 30,),
                      child: Text('Forget Password?'),
                    ),
                    SizedBox(height: 30,),
                    CustomButton(
                      onPressed: _isLoading ? null : _signIn,
                      text: 'Sign In', 
                      textColor: Colors.white,
                      isLoading: _isLoading,
                      backgroundGradient: AppGradients.primaryGradient,
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(left: 220, top: 50,),
                      child: Text('Dont have an account?',
                      style: TextStyle(color: Colors.grey),),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(left: 300, top: 5,),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        }, 
                        child: Text('Sign Up',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}