import 'package:fit_app/Screens/home_screens/main_screen.dart';
import 'package:fit_app/models/user_model.dart';
import 'package:fit_app/firebase_services/firestore_service.dart';
import 'package:flutter/material.dart';

class DataCollectionScreen extends StatefulWidget {
  const DataCollectionScreen({super.key});

  @override
  State<DataCollectionScreen> createState() => _DataCollectionScreenState();
}

class _DataCollectionScreenState extends State<DataCollectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _gender = 'Male';

  final _firestoreService = FirestoreService_user();

  void _submitData() async {
    if (_formKey.currentState!.validate()) {
      final userData = UserData(
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text),
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        gender: _gender,
      );

      await _firestoreService.saveUserData(userData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully')),
      );
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Your Data")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) =>
                    value!.isEmpty ? "Enter your name" : null,
              ),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Age"),
                validator: (value) =>
                    value!.isEmpty ? "Enter your age" : null,
              ),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Height (cm)"),
                validator: (value) =>
                    value!.isEmpty ? "Enter your height" : null,
              ),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Weight (kg)"),
                validator: (value) =>
                    value!.isEmpty ? "Enter your weight" : null,
              ),
              const SizedBox(height: 16),
              const Text("Gender", style: TextStyle(fontSize: 16)),
              RadioListTile(
                title: const Text('Male'),
                value: 'Male',
                groupValue: _gender,
                onChanged: (value) => setState(() => _gender = value!),
              ),
              RadioListTile(
                title: const Text('Female'),
                value: 'Female',
                groupValue: _gender,
                onChanged: (value) => setState(() => _gender = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
