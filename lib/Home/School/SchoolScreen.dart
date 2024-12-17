import 'package:flutter/material.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  State<SchoolScreen> createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  // Example school data
  final List<Map<String, String>> schools = [
    {"name": "Greenwood High", "location": "New York, USA", "description": "A prestigious school focusing on innovative teaching."},
    {"name": "Sunrise Academy", "location": "Los Angeles, USA", "description": "An inclusive school with a focus on holistic development."},
    {"name": "Blue Ridge School", "location": "San Francisco, USA", "description": "A school with a focus on art and creativity."},
    {"name": "Riverside International", "location": "London, UK", "description": "A well-established school offering international education."},
    {"name": "Oakwood College", "location": "Sydney, Australia", "description": "A renowned college known for its academic excellence."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schools List'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Schools',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: schools.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to a detailed school screen (Example)
                      print("Tapped on ${schools[index]['name']}");
                      // You could navigate to a detailed page if needed
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(schools[index]["name"]!),
                        subtitle: Text(
                          'Location: ${schools[index]["location"]}\nDescription: ${schools[index]["description"]}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: const Icon(Icons.school),
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
