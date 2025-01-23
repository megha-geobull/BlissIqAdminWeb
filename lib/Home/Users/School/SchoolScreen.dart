import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Home/Assign/AssignedMentorPage.dart';
import 'package:blissiqadmin/Home/Assign/AssignedStudentPage.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Models/AllSchoolModel.dart';
import 'package:blissiqadmin/Home/Users/School/SchoolRegistration.dart';
import 'package:blissiqadmin/auth/Controller/SchoolController/SchoolController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Global/constants/CustomAlertDialogue.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  _SchoolScreenState createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  final SchoolController schoolController = Get.put(SchoolController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      schoolController.getAllSchools();
    });

  }

  void _toggleStatus(String schoolId) async {
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
      var school = schoolController.allSchoolData
          .where((p0) => p0.id == schoolId)
          .first;

      schoolController.approveSchool(
        school_id: schoolId,
        approval_status: (school.approvalStatus == "Disapproved" || school.approvalStatus == "Pending") ? "Approved" : "Disapproved",
      );

    }
  }
  void _removeSchool(int index) {
    setState(() {
      schoolController.allSchoolData.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (schoolController.isLoading.value) {
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
                        child: _buildSchoolMainContent(),
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

  Widget _buildSchoolMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(child: _buildSchoolTable()),
        ],
      ),
    );
  }

  Widget _buildSchoolTable() {
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
            7: FlexColumnWidth(1),
            8: FlexColumnWidth(1),
          },
          children: [
            _buildTableHeader(),
            ...schoolController.allSchoolData.asMap().entries.map((entry) {
              int index = entry.key;
              Data mentor = entry.value;
              return _buildTableRow(mentor, index);
            }).toList(),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(Data school, int index) {
    return TableRow(
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(12.0),
        //   child: CircleAvatar(
        //     radius: 24,
        //     backgroundColor: Colors.grey.shade300,
        //     child: CachedNetworkImage(
        //       imageUrl: "${ApiString.ImgBaseUrl}${school.profileImage}",
        //       imageBuilder: (context, imageProvider) => Container(
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           image: DecorationImage(
        //             image: imageProvider,
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //       ),
        //       placeholder: (context, url) => const CircularProgressIndicator(),
        //       errorWidget: (context, url, error) => const Icon(Icons.person, size: 48, color: Colors.grey),
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(school.schoolName ?? 'No Name'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(school.principalEmail ?? 'No Email'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(school.principalPhone?.toString() ?? '-'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(school.address ?? 'No Address'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(school.schoolRegNumber ?? 'No school reg.no'),
        ), // Placeholder if experience is missing
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(school.schoolType ?? 'no type'),
        ), // Placeholder if qualification is missing
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            onPressed: () => _toggleStatus(school.id ?? ''),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: _getButtonColor(school.approvalStatus), // Dynamic color
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
            ),
            child: Text(
              school.approvalStatus ?? 'Pending',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssignedMentorPage(schoolID: school.id ?? ''),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('View', style: TextStyle(fontSize: 12,color: Colors.white)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssignedStudentPage(schoolID: school.id ?? ''),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('View', style: TextStyle(fontSize: 12,color: Colors.white)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              onDelete("You want to delete this school ?",index,school.id!);
              },
          ),
        ),
      ],
    );
  }

  void onDelete(String title,int index,String school_id) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Are you sure',
        content: title,
        yesText: 'Yes',
        noText: 'No', onYesPressed: () {
        Navigator.pop(context);
        schoolController.delete_school(school_id);
        Future.delayed(const Duration(seconds: 2), () {
          _removeSchool(index);
        });
      },
      ),
    );
  }

  Color _getButtonColor(String? approvalStatus) {
    switch (approvalStatus) {
      case "Approved":
        return AppColor.green;
      case "Disapproved":
        return AppColor.red;
      case "Pending":
        return AppColor.amber;
      default:
        return AppColor.grey;
    }
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
              'All Registered Schools',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Spacer(),
            Tooltip(
              message: 'Add a New School',
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SchoolRegistration()),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text("Add School",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
              ),
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
        // Padding(
        //   padding: EdgeInsets.all(12.0),
        //   child: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        // ),
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
          child: Text('Contact No', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('School Reg.no', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('School Type', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Mentor', style: TextStyle(fontWeight: FontWeight.bold)),
        ),Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Student', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

}















