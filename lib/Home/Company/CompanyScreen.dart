import 'package:flutter/material.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  // Example company data
  final List<Map<String, String>> companies = [
    {"name": "TechCorp", "industry": "Technology", "location": "San Francisco, USA", "description": "A leading tech company specializing in AI and Cloud Computing."},
    {"name": "HealthSolutions", "industry": "Healthcare", "location": "Los Angeles, USA", "description": "A company providing innovative healthcare solutions."},
    {"name": "EduTech", "industry": "Education", "location": "London, UK", "description": "An ed-tech company revolutionizing learning with technology."},
    {"name": "GreenEnergy", "industry": "Energy", "location": "Berlin, Germany", "description": "A company focused on sustainable and renewable energy solutions."},
    {"name": "Fashionista", "industry": "Fashion", "location": "Paris, France", "description": "A global fashion brand known for its cutting-edge designs."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Companies List'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Companies',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to a detailed company screen (Example)
                      print("Tapped on ${companies[index]['name']}");
                      // You could navigate to a detailed page if needed
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(companies[index]["name"]!),
                        subtitle: Text(
                          'Industry: ${companies[index]["industry"]}\nLocation: ${companies[index]["location"]}\nDescription: ${companies[index]["description"]}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: const Icon(Icons.business),
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
