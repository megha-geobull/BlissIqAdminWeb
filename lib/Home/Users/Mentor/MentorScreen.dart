import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Mentor/MentorRegistration.dart';
import 'package:flutter/material.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({super.key});

  @override
  _MentorScreenState createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  // Sample data for mentors
  final List<Map<String, String>> mentorData = [
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
    },
    {
      "profileImage": "",
      "Full Name": "Sai Kiran",
      "contact_no": "6543210987",
      "email": "sai.kiran@gmail.com",
      "Address": "Hyderabad, Telangana",
      "Experience": "5 years",
      "Qualification": "B.Sc. in Mathematics",
      "Introduction/Bio": "Loves teaching mathematics and science.",
      "Languages": "English, Telugu",
    },
    {
      "profileImage": "",
      "Full Name": "Anaya Singh",
      "contact_no": "5432109876",
      "email": "anaya.singh@gmail.com",
      "Address": "Bangalore, Karnataka",
      "Experience": "3 years",
      "Qualification": "B.A. in English Literature",
      "Introduction/Bio": "Avid reader and literature enthusiast.",
      "Languages": "English, Kannada",
    },
    {
      "profileImage": "",
      "Full Name": "Rohan Mehta",
      "contact_no": "4321098765",
      "email": "rohan.mehta@gmail.com",
      "Address": "Pune, Maharashtra",
      "Experience": "7 years",
      "Qualification": "M.Sc. in Physics",
      "Introduction/Bio": "Passionate about physics and research.",
      "Languages": "English, Marathi",
    },
    {
      "profileImage": "",
      "Full Name": "Isha Gupta",
      "contact_no": "3210987654",
      "email": "isha.gupta@gmail.com",
      "Address": "Chennai, Tamil Nadu",
      "Experience": "2 years",
      "Qualification": "B.Com",
      "Introduction/Bio": "Focused on finance and accounting.",
      "Languages": "English, Tamil",
    },
    {
      "profileImage": "",
      "Full Name": "Kabir Khan",
      "contact_no": "2109876543",
      "email": "kabir.khan@gmail.com",
      "Address": "Lucknow, Uttar Pradesh",
      "Experience": "9 years",
      "Qualification": "M.A. in History",
      "Introduction/Bio": "History buff and passionate educator.",
      "Languages": "English, Hindi",
    },
    {
      "profileImage": "",
      "Full Name": "Nisha Reddy",
      "contact_no": "1098765432",
      "email": "nisha.reddy@gmail.com",
      "Address": "Visakhapatnam, Andhra Pradesh",
      "Experience": "4 years",
      "Qualification": "B.Tech in Information Technology",
      "Introduction/Bio": "Tech enthusiast and mentor.",
      "Languages": "English, Telugu",
    },
    {
      "profileImage": "",
      "Full Name": "Karan Joshi",
      "contact_no": "0987654321",
      "email": "karan.joshi@gmail.com",
      "Address": "Jaipur, Rajasthan",
      "Experience": "5 years",
      "Qualification": "B.Sc. in Chemistry",
      "Introduction/Bio": "Chemistry lover and educator.",
      "Languages": "English, Hindi",
    },
  ];

  void _removeMentor(int index) {
    setState(() {
      mentorData.removeAt(index);
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
                    child: _buildMentorMainContent(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMentorMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(child: _buildMentorTable()),
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
              'All Registered Mentors',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
            ),
            const Spacer(),
            Tooltip(
              message: 'Add a New Mentor',
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  MentorRegistration()),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text("Add Mentor", style: TextStyle(color: Colors.white, fontSize: 16)),
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

  Widget _buildMentorTable() {
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

            7: FlexColumnWidth(1.6), // Actions
            8: FlexColumnWidth(2), // Details
          },
          children: [
            _buildTableHeader(),
            ...mentorData.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, String> mentor = entry.value;
              return _buildTableRow(mentor, index);
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
        Padding(padding: EdgeInsets.all(12.0), child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Details', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  TableRow _buildTableRow(Map<String, String> mentor, int index) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: [
        const Padding(padding: EdgeInsets.all(12.0), child: Icon(Icons.account_circle, size: 20)),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(mentor["Full Name"] ?? 'No Name', style: const TextStyle(fontSize: 14))),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(mentor["email"] ?? 'No Email', style: const TextStyle(fontSize: 14))),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(mentor["contact_no"] ?? 'No Contact No', style: const TextStyle(fontSize: 14))),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(mentor["Address"] ?? 'No Address', style: const TextStyle(fontSize: 14))),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(mentor["Experience"] ?? 'No Experience', style: const TextStyle(fontSize: 14))),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(mentor["Qualification"] ?? 'No Qualification', style: const TextStyle(fontSize: 14))),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeMentor(index),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
            child: TextButton(
              onPressed: () {
                // Handle view action
              },
              child: const Text("View", style: TextStyle(letterSpacing: 1, fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
          ),
        ),
      ],
    );
  }
}