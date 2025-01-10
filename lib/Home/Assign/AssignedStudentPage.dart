import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Models/GetMentorsAssignModel.dart';
import 'package:blissiqadmin/Home/Users/Models/GetSchoolsAssignModel.dart';
import 'package:blissiqadmin/auth/Controller/AuthController.dart';
import 'package:blissiqadmin/auth/Controller/CompanyController/CompanyController.dart';
import 'package:blissiqadmin/auth/Controller/SchoolController/SchoolController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignedStudentPage extends StatefulWidget {
  final String schoolID;
  const AssignedStudentPage({super.key, required this.schoolID});

  @override
  State<AssignedStudentPage> createState() => _AssignedStudentPageState();
}

class _AssignedStudentPageState extends State<AssignedStudentPage> {

  final AuthController  authController = Get.put(AuthController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.getAssignedMentorsApi(widget.schoolID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (authController.isLoading.value) {
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
                        title: const Text('Assigned Students'),
                        backgroundColor: Colors.blue.shade100,
                      ),
                      body: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 24),
                        child: _buildAssignMentorMainContent(),
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

  Widget _buildAssignMentorMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(child: _buildAssignMentorTable()),
        ],
      ),
    );
  }

  Widget _buildAssignMentorTable() {
    return SingleChildScrollView(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Table(
          border: const TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey, width: 0.5),
          ),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(2),
            5: FlexColumnWidth(2),
            6: FlexColumnWidth(2),
            7: FlexColumnWidth(2),
          },
          children: [
            _buildTableHeader(),
            ...authController.allAssignMentorData.asMap().entries.map((entry) {
              int index = entry.key;
              AllAssignedMentorsData mentor = entry.value;
              return _buildTableRow(mentor, index);
            }).toList(),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(AllAssignedMentorsData assignMentor, int index) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignMentor.fullName ?? 'No Name',
              style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignMentor.email ?? 'No Email',
              style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignMentor.contactNo?.toString() ?? 'No Contact',
              style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignMentor.address ?? 'No Address',
              style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignMentor.experience ?? 'No Experience',
              style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignMentor.qualification ?? 'No Qualification',
              style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignMentor.status ?? 'No Status',
              style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignMentor.approvalStatus ?? 'No Approval',
              style: const TextStyle(fontSize: 16)),
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
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Text(
              'All Assigned Students',
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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      children: const [
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Contact No', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Address', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Experience', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Qualification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Approval', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ],
    );
  }
}
