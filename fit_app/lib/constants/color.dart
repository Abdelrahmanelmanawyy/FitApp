import 'package:flutter/material.dart';

class AppColors {
  // Define your colors here
  static const Color primaryColor = Color.fromARGB(255, 22, 106, 151); // 0F405A
  static const Color secondaryColor = Color(0xFF2188C0); // 2188C0
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0F405A), Color(0xFF2188C0)], // Your colors
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color.fromARGB(186, 33, 136, 192), Color.fromARGB(199, 15, 64, 90)], // Reverse gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
