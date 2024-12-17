import 'package:flutter/material.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  // Example attendance data (you can replace this with real data from a database or API)
  final List<Map<String, String>> attendanceData = [
    {"date": "2024-12-01", "status": "Present"},
    {"date": "2024-12-02", "status": "Absent"},
    {"date": "2024-12-03", "status": "Present"},
    {"date": "2024-12-04", "status": "Late"},
    {"date": "2024-12-05", "status": "Present"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Student Attendance History',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: attendanceData.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text('Date: ${attendanceData[index]["date"]}'),
                      subtitle: Text('Status: ${attendanceData[index]["status"]}'),
                      leading: const Icon(Icons.calendar_today),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
