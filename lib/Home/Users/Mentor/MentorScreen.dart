import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Mentor/MentorRegistration.dart';
import 'package:blissiqadmin/Home/Users/Models/GetAllMentorModel.dart';
import 'package:blissiqadmin/auth/Controller/AuthController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({super.key});

  @override
  _MentorScreenState createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  final AuthController mentorController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mentorController.getAllMentors();
    });

  }

  void _toggleStatus(String mentorId) async {
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
      var mentor = mentorController.allMentorData
          .where((p0) => p0.sId == mentorId)
          .first;

      mentorController.approveMentors(
        mentor_id: mentorId,
        approval_status: (mentor.approvalStatus == "Disapproved" || mentor.approvalStatus == "Pending") ? "Approved" : "Disapproved",
      );

    }
  }

  void _removeMentor(int index) {
    setState(() {
      mentorController.allMentorData.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (mentorController.isLoading.value) {
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
                        child: _buildMentorMainContent(),
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

  Widget _buildMentorTable() {
    return SingleChildScrollView(
      child: Card(
        elevation: 0.8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Table(
          border: const TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey, width: 0.5),
          ),
          columnWidths: const {
            0: FlexColumnWidth(1.5), // Profile column
            1: FlexColumnWidth(1.5), // Name column
            2: FlexColumnWidth(2.5), // Email column (increased width)
            3: FlexColumnWidth(1.5), // Contact No column
            4: FlexColumnWidth(1.5), // Address column
            5: FlexColumnWidth(1.5), // Experience column
            6: FlexColumnWidth(1.5), // Qualification column
            7: FlexColumnWidth(2.0), // Status column (increased width)
            8: FlexColumnWidth(1.5), // Actions column
          },
          children: [
            _buildTableHeader(),
            ...mentorController.allMentorData.asMap().entries.map((entry) {
              int index = entry.key;
              Data mentor = entry.value;
              return _buildTableRow(mentor, index);
            }).toList(),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(Data mentor, int index) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: CachedNetworkImage(
              imageUrl: ApiString.ImgBaseUrl + (mentor.profileImage ?? ''),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,

            ),
          ),

        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(mentor.fullName ?? 'No Name'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(mentor.email ?? 'No Email'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(mentor.contactNo?.toString() ?? '-'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(mentor.address ?? 'No Address'),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(mentor.experience ?? 'No experience'),
        ), // Placeholder if experience is missing
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(mentor.qualification ?? 'not mention'),
        ), // Placeholder if qualification is missing
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            onPressed: () => _toggleStatus(mentor.sId ?? ''),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: _getButtonColor(mentor.approvalStatus), // Dynamic color
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
            ),
            child: Text(
              mentor.approvalStatus ?? 'Pending',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeMentor(index),
          ),
        ),
      ],
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
              'All Registered Mentors',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Spacer(),
            Tooltip(
              message: 'Add a New Mentor',
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MentorRegistration()),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text("Add Mentor",
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
          child: Text('Contact No', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Address', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Experience', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Qualification', style: TextStyle(fontWeight: FontWeight.bold)),
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















