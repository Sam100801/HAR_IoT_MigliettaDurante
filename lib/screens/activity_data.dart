import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting datetime

// Model class for activity data
class ActivityData {
  final String activity;
  final DateTime time;
  final String prediction;

  // Constructor with default values
  ActivityData({
    this.activity = "Unknown",
    DateTime? time,
    this.prediction = "Unknown",
  }) : time = time ?? DateTime.now(); // Set default time if null
}

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  // Sample data
  final List<ActivityData> _activityData = [
    ActivityData(activity: "Running", time: DateTime.now().subtract(Duration(minutes: 1)), prediction: "Run"),
    ActivityData(activity: "Walking", time: DateTime.now().subtract(Duration(minutes: 5)), prediction: "Walk"),
    ActivityData(activity: "Stopping", time: DateTime.now().subtract(Duration(minutes: 10)), prediction: "Stop"),
  ];

  // Function to format date and time
  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dati delle attività svolte'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _activityData.length,
          itemBuilder: (context, index) {
            final data = _activityData[index];
            return _buildActivityCard(data); // Ensure this returns a Widget
          },
        ),
      ),
    );
  }

  // Method to build a card for each activity data
  Widget _buildActivityCard(ActivityData data) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: Colors.teal,
                  size: 30,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    data.activity,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.grey,
                  size: 24,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Time: ${formatDateTime(data.time)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.assessment,
                  color: Colors.grey,
                  size: 24,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Prediction: ${data.prediction}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
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

void main() => runApp(MaterialApp(
  home: ActivityScreen(),
));
