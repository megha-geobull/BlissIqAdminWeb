import 'package:flutter/material.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  // Sample data for teachers
  final List<Map<String, String>> teacherData = [
    {
      "profileImage": "",
      "Full Name": "Aarav Sharma",
      "contact_no": "9876543210",
      "email": "aarav.sharma@gmail.com",
      "Address": "Mumbai, Maharashtra",
      "Experience": "6 years",
      "Qualification": "M.Tech",
      "Introduction/Bio": "Passionate about teaching and technology.",
      "Languages": "English, Hindi",
      "Subjects": "Maths, Physics",
    },
    {
      "profileImage": "",
      "Full Name": "Vivaan Patel",
      "contact_no": "8765432109",
      "email": "vivaan.patel@gmail.com",
      "Address": "Ahmedabad, Gujarat",
      "Experience": "4 years",
      "Qualification": "B.E. in Computer Science",
      "Introduction/Bio": "Expert in software development and mentoring.",
      "Languages": "English, Gujarati",
      "Subjects": "Computer Science, Engineering",
    },
    {
      "profileImage": "",
      "Full Name": "Aditya Verma",
      "contact_no": "7654321098",
      "email": "aditya.verma@gmail.com",
      "Address": "Delhi",
      "Experience": "8 years",
      "Qualification": "MBA",
      "Introduction/Bio": "Specializes in business management.",
      "Languages": "English, Hindi",
      "Subjects": "Business Studies, Economics",
    },
    // Add more teacher data if needed...
  ];

  void _removeTeacher(int index) {
    setState(() {
      teacherData.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;

          return Row(
            children: [
              if (isWideScreen)
                Container(
                  width: 250,
                  color: Colors.orange.shade100,
                  child: const MyDrawer(),
                ),
              Expanded(
                child: Scaffold(
                  appBar: isWideScreen
                      ? null
                      : AppBar(
                    title: const Text('Dashboard'),
                    backgroundColor: Colors.blue.shade100,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.grey),
                        onPressed: () {
                          // Handle notifications
                        },
                      ),
                    ],
                  ),
                  drawer: isWideScreen ? null : Drawer(child: const MyDrawer()),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                    child: _buildTeacherMainContent(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTeacherMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(child: _buildTeacherTable()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Text(
              'All Registered Teachers',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
            ),
            const Spacer(),
            Tooltip(
              message: 'Add a New Teacher',
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const TeacherRegistration()),
                  // );
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text("Add Teacher", style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherTable() {
    return SingleChildScrollView(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Table(
          border: const TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey, width: 0.5),
            outside: BorderSide.none,
          ),
          columnWidths: const {
            0: FlexColumnWidth(2), // Profile
            1: FlexColumnWidth(2), // Name
            2: FlexColumnWidth(3), // Email
            3: FlexColumnWidth(2), // Contact No
            4: FlexColumnWidth(3), // Address
            5: FlexColumnWidth(2), // Experience
            6: FlexColumnWidth(2), // Qualification
            7: FlexColumnWidth(2), // Subjects
            8: FlexColumnWidth(1.6), // Actions
            9: FlexColumnWidth(2), // Details
          },
          children: [
            _buildTableHeader(),
            ...teacherData.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, String> teacher = entry.value;
              return _buildTableRow(teacher, index);
            }).toList(),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      children: const [
        Padding(padding: EdgeInsets.all(12.0), child: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Contact No', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Address', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Experience', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Qualification', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Subjects', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Details', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  TableRow _buildTableRow(Map<String, String> teacher, int index) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: [
        const Padding(padding: EdgeInsets.all(12.0), child: Icon(Icons.account_circle, size: 20)),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(teacher["Full Name"] ?? 'No Name', style: const TextStyle(fontSize: 14))),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(teacher["email"] ?? 'No Email', style: const TextStyle(fontSize: 14))),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(teacher["contact_no"] ?? 'No Contact No', style: const TextStyle(fontSize: 14))),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(teacher["Address"] ?? 'No Address', style: const TextStyle(fontSize: 14))),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(teacher["Experience"] ?? 'No Experience', style: const TextStyle(fontSize: 14))),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(teacher["Qualification"] ?? 'No Qualification', style: const TextStyle(fontSize: 14))),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(teacher["Subjects"] ?? 'No Subjects', style: const TextStyle(fontSize: 14))),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            onPressed: () => _removeTeacher(index),
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            onPressed: () {
              // Navigate to the details screen if needed
            },
            icon: const Icon(Icons.arrow_forward, size: 20),
          ),
        ),
      ],
    );
  }
}
