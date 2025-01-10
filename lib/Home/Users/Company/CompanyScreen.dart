import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Company/CompanyRegistrationPage.dart';
import 'package:blissiqadmin/Home/Users/Company/CompnayListBottomSheet.dart';
import 'package:blissiqadmin/auth/Controller/CompanyController/CompanyController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/GetAllCompanyModel.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final CompanyController companyController = Get.put(CompanyController());
  String? selectedSchool;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      companyController.getAllCompany();
    });

  }

  void _toggleStatus(String companyId) async {
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
      var company = companyController.allCompanyData.firstWhere((p0) => p0.id == companyId);
      if (kDebugMode) {
        print("Company ID: $companyId");
      }
      String newStatus = (company.approvalStatus?.toLowerCase() == "disapproved" ||
          company.approvalStatus?.toLowerCase() == "pending")
          ? "Approved"
          : "Disapproved";
      await companyController.approveCompany(
        companyID: companyId,
        approvalStatus: newStatus,
      );
    }
  }

  void _removeCompany(int index) {
    setState(() {
      companyController.allCompanyData.removeAt(index);
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
                        title: const Text('Dashboard'),
                        backgroundColor: Colors.blue.shade100,
                      ),
                      body: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 16),
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
        elevation: 0.8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Table(
          border: const TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey, width: 0.5),
          ),
          columnWidths: const {
            0: FlexColumnWidth(1.5),
            1: FlexColumnWidth(1.5),
            2: FlexColumnWidth(1.5),
            3: FlexColumnWidth(1.5),
            4: FlexColumnWidth(1.5),
            5: FlexColumnWidth(1.5),
            6: FlexColumnWidth(1.5),
            7: FlexColumnWidth(1.5),
            8: FlexColumnWidth(1.5),
            9: FlexColumnWidth(1.6),
            10: FlexColumnWidth(1.5),

          },
          children: [
            _buildTableHeader(),
            ...companyController.allCompanyData.asMap().entries.map((entry) {
              int index = entry.key;
              Data mentor = entry.value;
              return _buildTableRow(mentor, index);
            }).toList(),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(Data company, int index) {
    return TableRow(
      children: [

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: CachedNetworkImage(
              imageUrl: ApiString.ImgBaseUrl + (company.profilePic ?? ''),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,

            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(company.ownerName ?? 'No Name'),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(company.companyName ?? 'No Name'),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(company.email ?? 'No Email'),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(company.contactNo?.toString() ?? '-'),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(company.gstNumber ?? 'No Gst Number'),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(company.cinNumber ?? 'No cinNumber'),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(company.panCard ?? 'not Pan Card'),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
            onPressed: () => _toggleStatus(company.id ?? ''),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: _getButtonColor(company.approvalStatus),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
            ),
            child: Text(
              company.approvalStatus ?? 'Pending',
              style: const TextStyle(
                color: Colors.black,fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: InkWell(
              onTap: () {
                print("Company.Id ${company.id}");
                _showSchoolBottomSheet(context, company.id);
              },
              borderRadius: BorderRadius.circular(10),
              child: const Text(
                'Assign',
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeCompany(index),
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
              'All Registered Companies',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Spacer(),
            Tooltip(
              message: 'Add a New Company',
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompanyRegistrationPage()),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text("Add Company",
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
          child: Text('Owner Name', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Company Name', style: TextStyle(fontWeight: FontWeight.bold)),
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
          child: Text('GST No', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Cin Number', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Pan Card No', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Assign', style: TextStyle(fontWeight: FontWeight.bold)),
        ),

        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _showSchoolBottomSheet(BuildContext context, String? id) async {
    selectedSchool = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        String? companyID = id;
        return CompnayListBottomSheet(companyID);
      },
    );
    if (selectedSchool != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Assigned to $selectedSchool')),
      );
    }
  }

}















