import 'package:fit_app/constants/color.dart';
import 'package:flutter/material.dart';

class DistanceAppBarWidget extends StatelessWidget {
  const DistanceAppBarWidget({super.key, required this. donemeter,});
  final double donemeter;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      height: 230,
      width: double.infinity,
      child:  SafeArea(
        child: Padding(
          padding: EdgeInsets.all(22.0),
          child: WeeklyGoalCard(goalKm: 50, doneKm: donemeter),
        ),
      ),
    );
  }
}

class WeeklyGoalCard extends StatefulWidget {
  final double goalKm;
  final double doneKm;

  const WeeklyGoalCard({super.key, required this.goalKm, required this.doneKm});

  @override
  State<WeeklyGoalCard> createState() => _WeeklyGoalCardState();
}

class _WeeklyGoalCardState extends State<WeeklyGoalCard> {
  late double _goalKm;
  late double _doneKm;

  @override
  void initState() {
    super.initState();
    _goalKm = widget.goalKm;
    _doneKm = widget.doneKm;
  }
  @override
void didUpdateWidget(covariant WeeklyGoalCard oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (widget.doneKm != oldWidget.doneKm) {
    setState(() {
      _doneKm = widget.doneKm;
    });
  }
}

  void _showEditGoalDialog() {
    final TextEditingController controller = TextEditingController(
      text: _goalKm.toInt().toString(),
    );
    

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Edit Weekly Goal'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Goal (m)',
              hintText: 'Enter your weekly goal in kilometers',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                final newGoal = double.tryParse(controller.text);
                if (newGoal != null && newGoal > 0) {
                  setState(() {
                    _goalKm = newGoal;
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('SAVE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double remainingKm = _goalKm - _doneKm;
    final double progressPercentage = _doneKm / _goalKm;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Week goal  ${_goalKm.toInt()} m',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                IconButton(
                  onPressed: _showEditGoalDialog,
                  icon: Image.asset(
                    "images/edit_icon.png",
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progressPercentage.clamp(0.0, 1.0),
                backgroundColor: const Color(0xFFE0E0E0),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 22, 106, 151),
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_doneKm.toInt()} m done',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
                Text(
                  '${remainingKm.toInt()} m left',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
