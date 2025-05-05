
import 'package:fit_app/constants/color.dart';
import 'package:fit_app/models/calories_cal_model.dart';
import 'package:flutter/material.dart';



class CalculationWidget extends StatelessWidget {
  final String goal;
  final int age;
  final int height;
  final int weight;
  final String gender;
  final String activity;
  final ValueChanged<int> onResult;

  const CalculationWidget({
    super.key,
    required this.goal,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.activity,
    required this.onResult,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CalculationButton(
        text: 'Calculate',
         onPressed: () {
          final result = CalorieCalculator.calculate(
            goal: goal,
            age: age,
            height: height,
            weight: weight,
            gender: gender,
            activity: activity,
          );
          onResult(result);
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Calculation Complete'),
              content: Text('Your daily calorie target is $result calories.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },)
    );
  }
}

class CalculationButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient backgroundColor;
  final IconData? icon; // Optional icon
  final double borderRadius; // Optional border radius
  
  const CalculationButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppGradients.primaryGradient,
    this.icon,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color:  Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}