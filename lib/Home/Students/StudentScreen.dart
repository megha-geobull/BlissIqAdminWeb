import 'package:flutter/material.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  // Example student data
  final List<Map<String, String>> students = [
    {"name": "John Doe", "grade": "A", "status": "Active"},
    {"name": "Jane Smith", "grade": "B", "status": "Active"},
    {"name": "Samuel Lee", "grade": "C", "status": "Inactive"},
    {"name": "Lily Brown", "grade": "A", "status": "Active"},
    {"name": "Oliver Green", "grade": "B", "status": "Active"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Students',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text('Name: ${students[index]["name"]}'),
                      subtitle: Text('Grade: ${students[index]["grade"]}'),
                      trailing: Text(
                        students[index]["status"]!,
                        style: TextStyle(
                          color: students[index]["status"] == "Active"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      leading: const Icon(Icons.person),
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
