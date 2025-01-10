import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Models/GetSchoolsAssignModel.dart';
import 'package:blissiqadmin/auth/Controller/CompanyController/CompanyController.dart';
import 'package:blissiqadmin/auth/Controller/SchoolController/SchoolController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignedSchoolPage extends StatefulWidget {
  final String companyID;
  const AssignedSchoolPage({super.key, required this.companyID});

  @override
  State<AssignedSchoolPage> createState() => _AssignedSchoolPageState();
}

class _AssignedSchoolPageState extends State<AssignedSchoolPage> {
  final CompanyController companyController = Get.put(CompanyController());
  final SchoolController schoolController = Get.put(SchoolController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      companyController.getAssignedSchoolsApi(widget.companyID);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (companyController.isLoading.value) {
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
                        title: const Text('Assigned Schools'),
                        backgroundColor: Colors.blue.shade100,
                      ),
                      body: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 24),
                        child: _buildCompanyMainContent(),
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

  Widget _buildCompanyMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(child: _buildCompanyTable()),
        ],
      ),
    );
  }

  Widget _buildCompanyTable() {
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
            ...companyController.allAssignSchoolData.asMap().entries.map((entry) {
              int index = entry.key;
              AllAssignedSchoolsData school = entry.value;
              return _buildTableRow(school, index);
            }).toList(),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(AllAssignedSchoolsData assignSchool, int index) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignSchool.schoolName ?? 'No Name',
              style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignSchool.schoolRegNumber ?? 'No Number',
              style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignSchool.principalEmail ?? 'No Email',
              style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignSchool.principalPhone?.toString() ?? '-',
              style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignSchool.address ?? 'No Address',
              style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignSchool.status ?? 'Inactive',
              style: const TextStyle(fontSize: 16)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          child: Text(assignSchool.schoolType ?? 'Unknown',
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
              'All Assigned Schools',
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
          child: Text(
            'School Name',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Registration No',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Principal Email',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Phone No',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Address',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Status',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'School Type',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
