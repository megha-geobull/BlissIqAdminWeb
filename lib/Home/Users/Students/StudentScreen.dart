import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Mentor/MentorListBottomSheet.dart';
import 'package:blissiqadmin/Home/Users/Models/AllStudentModel.dart';
import 'package:blissiqadmin/auth/Controller/StudentController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'MentorListScreen.dart'; // Import the new Mentor List screen

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final StudentController studentController = Get.put(StudentController());
  String? selectedMentor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      studentController.getAllLearners();
    });
  }

  void _toggleStatus(int index) async {
    bool? confirmation = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Action"),
          content: const Text("Are you sure you want to change the status?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Yes", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );

    if (confirmation == true) {
      setState(() {
        var mentor = studentController.allLearnerData[index];
        mentor.status = (mentor.status == "Approve") ? "Disapprove" : "Approve";
      });
    }
  }

  void _removeStudent(int index) {
    setState(() {
      studentController.allLearnerData.removeAt(index);
    });
  }


    void _showMentorBottomSheet(BuildContext context, String? sId) async {
     selectedMentor = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        String? studentID = sId;
        return MentorListBottomSheet(studentID);
      },
    );
    if (selectedMentor != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Assigned to $selectedMentor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (studentController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return LayoutBuilder(
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
                            ),
                      body: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16),
                        child: _buildStudentMainContent(),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      }),
    );
  }

  Widget _buildStudentMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(child: _buildStudentTable()),
        ],
      ),
    );
  }

  Widget _buildStudentTable() {
    return SingleChildScrollView(
      child: Card(
        elevation: 0.8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Table(
          border: const TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey, width: 0.5),
          ),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1.8),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),
            6: FlexColumnWidth(1),
          },
          children: [
            _buildTableHeader(),
            ...studentController.allLearnerData.asMap().entries.map((entry) {
              int index = entry.key;
              Data student = entry.value;
              return _buildTableRow(student, index);
            }).toList(),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(Data student, int index) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(student.profileImage ?? ''),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(student.userName ?? 'No Name'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(student.email ?? 'No Email'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(student.contactNo?.toString() ?? '-'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(student.school ?? 'No school'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(student.language ?? 'No provided'),
        ), // Placeholder if experience is missing
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(student.purpose ?? 'not provided'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: selectedMentor == null
              ? ElevatedButton(
            onPressed: () {
              print("student.sId ${student.sId}");
              _showMentorBottomSheet(context, student.sId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child:
            const Text(
              'Assign',
              style: TextStyle(
                letterSpacing: 1,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
              :
          Text(
            'Assigned to $selectedMentor',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: ElevatedButton(
        //     onPressed: () {
        //       print("student.sId ${student.sId}");
        //       _showMentorBottomSheet(context,student.sId);
        //     },
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: Colors.green,
        //       shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(10)),
        //       ),
        //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        //     ),
        //     child: const Text(
        //       'Assign',
        //       style: TextStyle(
        //         letterSpacing: 1,
        //         fontSize: 12,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeStudent(index),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
      ),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              'All Registered Student',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
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
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child:
              Text('Contact No', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('School', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child:
              Text('Language', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Purpose', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

