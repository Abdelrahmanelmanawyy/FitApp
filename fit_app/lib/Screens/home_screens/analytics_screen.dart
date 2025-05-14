import 'package:fit_app/firebase_services/firestore_service.dart';
import 'package:fit_app/widgets/home_widgets/chart_screen_widgets/mucelchartwidget.dart';
import 'package:fit_app/widgets/home_widgets/chart_screen_widgets/workoutchart.dart';
import 'package:flutter/material.dart';


class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateTime _selectedMonth = DateTime.now();
  final FirestoreService_workout firestoreService = FirestoreService_workout();
   final Map<String, Map<String, int>> workoutData = {
      '': {'strength': 5,},
      '2': {'strength': 6,},
      '3': {'strength': 7,},
      '4': {'strength': 4,},
      
    };
  

  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + offset,
      );
    });
  }

  String _getMonthName(DateTime date) {
    return [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ][date.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 180),
              child: Text('Overview', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 30,),

            StreamBuilder<Map<String, int>>(
              stream: firestoreService.getMuscleGroupFrequency(
                filterMonth: _selectedMonth,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
            
               
                
                final muscleData = snapshot.data!;
                final monthName = _getMonthName(_selectedMonth);
            
                return Expanded(
                  
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MuscleTrainingChart(
                          muscleData: muscleData,
                          month: monthName,
                          size: 250,
                          onPrevious: () => _changeMonth(-1),
                          onNext: () => _changeMonth(1),
                        ),
                        SizedBox(height:20),
                        WorkoutChart(data:workoutData)
                       
                        
                        
                      ],
                    ),
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
