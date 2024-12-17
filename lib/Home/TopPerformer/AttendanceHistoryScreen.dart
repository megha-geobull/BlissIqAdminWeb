import 'package:flutter/material.dart';

class TopPerformingStudentsScreen extends StatefulWidget {
  const TopPerformingStudentsScreen({super.key});

  @override
  State<TopPerformingStudentsScreen> createState() => _TopPerformingStudentsScreenState();
}

class _TopPerformingStudentsScreenState extends State<TopPerformingStudentsScreen> {
  // Example student data
  final List<Map<String, String>> students = [
    {"name": "John Doe", "grade": "A+", "score": "95", "rank": "1"},
    {"name": "Jane Smith", "grade": "A", "score": "92", "rank": "2"},
    {"name": "Emily White", "grade": "A", "score": "90", "rank": "3"},
    {"name": "Michael Brown", "grade": "B+", "score": "85", "rank": "4"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Performing Students'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top 10 Performers',
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
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the detailed profile of the student
                      print("Tapped on ${students[index]['name']}");
                      // You can navigate to a student profile page here
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(students[index]["name"]!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Grade: ${students[index]["grade"]}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Score: ${students[index]["score"]}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Rank: ${students[index]["rank"]}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        leading: const Icon(Icons.star, color: Colors.yellow),
                      ),
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
