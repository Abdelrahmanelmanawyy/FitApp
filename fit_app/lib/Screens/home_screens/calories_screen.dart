import 'package:fit_app/firebase_services/firestore_service.dart';
import 'package:fit_app/widgets/home_widgets/calories_screen_widgets/caloriescalculation.dart';
import 'package:fit_app/widgets/home_widgets/calories_screen_widgets/caloriescard.dart';
import 'package:fit_app/widgets/home_widgets/calories_screen_widgets/caloriesfiled.dart';
import 'package:flutter/material.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({Key? key}) : super(key: key);

  @override
  _CaloriesScreenState createState() => _CaloriesScreenState();
}

class _CaloriesScreenState extends State<CaloriesScreen> {
  final FirestoreService_user _firestoreService = FirestoreService_user();

  String goal = 'select';
  int age = 20;
  int height = 170;
  int weight = 70;
  String gender = 'select';
  String activity = 'select';

  int calories = 0;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }
Future<void> loadUserData() async {
  final userData = await _firestoreService.getUserData();
  setState(() {
    // Set default values if no data is found
    age = userData?.age ?? 20;
    height = userData?.height.toInt() ?? 170;
    weight = userData?.weight.toInt() ?? 70;
    gender = userData?.gender ?? 'select';
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 110, top: 10),
              child: Text(
                'Calories Calculation',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            CaloriesCard(calories: calories, maxCalories: 3000),
            const SizedBox(height: 16),

            // Goal
            Caloriesfiled(
              label: 'Goal',
              value: goal,
              valueColor: const Color.fromARGB(255, 22, 106, 151),
              onTap: () => showOptionsDialog(
                'Select Goal',
                ['Lose weight', 'Maintain weight', 'Gain weight'],
                (value) => setState(() => goal = value),
              ),
            ),
            const Divider(height: 1),

            // Age
            Caloriesfiled(
              label: 'Age',
              value: '$age years',
              onTap: () => showNumberPicker(
                'Select Age',
                0,
                100,
                age,
                (value) => setState(() => age = value),
              ),
            ),
            const Divider(height: 1),

            // Height
            Caloriesfiled(
              label: 'Height',
              value: '$height cm',
              onTap: () => showNumberPicker(
                'Select Height',
                120,
                220,
                height,
                (value) => setState(() => height = value),
              ),
            ),
            const Divider(height: 1),

            // Weight
            Caloriesfiled(
              label: 'Weight',
              value: '$weight kg',
              onTap: () => showNumberPicker(
                'Select Weight',
                10,
                200,
                weight,
                (value) => setState(() => weight = value),
              ),
            ),
            const Divider(height: 1),

            // Gender
            Caloriesfiled(
              label: 'Gender',
              value: gender,
              valueColor: const Color.fromARGB(255, 22, 106, 151),
              onTap: () => showOptionsDialog(
                'Select Gender',
                ['Male', 'Female'],
                (value) => setState(() => gender = value),
              ),
            ),
            const Divider(height: 1),

            // Activity
            Caloriesfiled(
              label: 'Activity',
              value: activity,
              valueColor: const Color.fromARGB(255, 22, 106, 151),
              onTap: () => showOptionsDialog(
                'Select Activity Level',
                [
                  'Sedentary',
                  'Lightly active',
                  'Moderately active',
                  'Active',
                  'Very active'
                ],
                (value) => setState(() => activity = value),
              ),
            ),
            const Divider(height: 1),

            const SizedBox(height: 20),

            CalculationWidget(
              goal: goal,
              age: age,
              height: height,
              weight: weight,
              gender: gender,
              activity: activity,
              onResult: (value) => setState(() => calories = value),
            ),
          ],
        ),
      ),
    );
  }

  void showOptionsDialog(
    String title,
    List<String> options,
    ValueChanged<String> onSelect,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(options[index]),
                onTap: () {
                  Navigator.of(context).pop();
                  onSelect(options[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void showNumberPicker(
    String title,
    int min,
    int max,
    int currentValue,
    ValueChanged<int> onSelect,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        int selectedValue = currentValue;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$selectedValue',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Slider(
                  value: selectedValue.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: max - min,
                  label: selectedValue.toString(),
                  onChanged: (value) =>
                      setState(() => selectedValue = value.round()),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onSelect(selectedValue);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
}
