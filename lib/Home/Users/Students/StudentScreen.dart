import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Mentor/MentorListBottomSheet.dart';
import 'package:blissiqadmin/Home/Users/Models/AllStudentModel.dart';
import 'package:blissiqadmin/auth/Controller/StudentController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Global/constants/CustomAlertDialogue.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final StudentController studentController = Get.put(StudentController());
  //String? selectedMentor;
  Map<String, String?> assignedMentors = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await studentController.getAllLearners();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load students: $e')),
        );
      }
    });
  }

  void _removeStudent(int index) {
    setState(() {
      studentController.allLearnerData.removeAt(index);
    });
  }

  // void _removeStudent(String? index) {
  //   setState(() {
  //     studentController.deleteStudentAPI(studentID: index.toString());
  //   });
  // }

  void _showMentorBottomSheet(BuildContext context, String? studentId) async {
    String? selectedMentor = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return MentorListBottomSheet(studentId);
      },
    );
    if (selectedMentor != null) {
      setState(() {
        assignedMentors[studentId!] = selectedMentor;
      });
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
          child: Text('Mentor', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  TableRow _buildTableRow(Data student, int index) {
    return TableRow(
      children: [
        // Profile Image
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade300,
            child: student.profileImage != null && student.profileImage!.isNotEmpty
                ? CachedNetworkImage(
              imageUrl: "${ApiString.ImgBaseUrl}${student.profileImage}",
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
              const Icon(Icons.person, size: 48, color: Colors.grey),
            )
                : const Icon(Icons.person, size: 48, color: Colors.grey),
          ),
        ),
        // User Name
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(student.userName ?? 'No Name'),
        ),
        // Email
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(student.email ?? 'No Email'),
        ),
        // Contact Number
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(student.contactNo?.toString() ?? '-'),
        ),
        // School
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(student.school ?? 'No School'),
        ),
        // Language
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(student.language ?? 'No Language Provided'),
        ),
        // Purpose
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(student.purpose ?? 'Not Provided'),
        ),
        // Mentor Assignment
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: assignedMentors[student.id] == null
              ? ElevatedButton(
            onPressed: () => _showMentorBottomSheet(context, student.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: const Text(
              'Assign',
              style: TextStyle(
                letterSpacing: 1,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
              : Text(
            '${assignedMentors[student.id]}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: (){
              onDelete("You want to delete learner ?",index,student.id);
              } ,
          ),
        ),
      ],
    );
  }

  void onDelete(String title,int index,String learner_id) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Are you sure',
        content: title,
        yesText: 'Yes',
        noText: 'No', onYesPressed: () {
        Navigator.pop(context);
        studentController.delete_Learners(learner_id);
        Future.delayed(const Duration(seconds: 2), () {
          _removeStudent(index);
          //studentController.getAllLearners();
        });
      },
      ),
    );
  }
}