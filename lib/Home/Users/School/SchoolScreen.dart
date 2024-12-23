import 'dart:io';

import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  _SchoolScreenState createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  final List<Map<String, String>> schoolData = [
    {
      "profile": "",
      "schoolName": "Nath High School Paithan",
      "schoolRegNumber": "NHSP12345",
      "principalName": "Dr. A. Kulkarni",
      "principalEmail": "principal@nathhs.com",
      "principalPhone": "9823456789",
      "address": "Paithan Road, Aurangabad, Maharashtra",
      "schoolType": "Private",
      "affiliatedCompany": "Yes"
    },
    {
      "profile": "",
      "schoolName": "Gurukul International School",
      "schoolRegNumber": "GIS67890",
      "principalName": "Mrs. S. Deshmukh",
      "principalEmail": "principal@gurukul.com",
      "principalPhone": "9812345678",
      "address": "Pune Road, Nashik, Maharashtra",
      "schoolType": "CBSE",
      "affiliatedCompany": "No"
    },
  ];

  void _removeSchool(int index) {
    setState(() {
      schoolData.removeAt(index);
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
                  child: MyDrawer(),
                ),
              Expanded(
                child: Scaffold(
                  appBar: isWideScreen
                      ? null
                      : AppBar(
                    title: const Text('Dashboard'),
                    scrolledUnderElevation: 0,
                    backgroundColor: Colors.blue.shade100,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  drawer: isWideScreen ? null : Drawer(child: MyDrawer()),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                    child: _buildSchoolMainContent(constraints),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSchoolMainContent(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: _buildSchoolTable(),
            ),
          ),
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
              'All Registered Schools',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
            ),
            const Spacer(),
            Tooltip(
              message: 'Add a New School',
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text("Add School", style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
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

  Widget _buildSchoolTable() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Table(
        border: const TableBorder.symmetric(
          inside: BorderSide(color: Colors.grey, width: 0.5),
        ),
        columnWidths: const {
          0: FlexColumnWidth(2), // Name
          1: FlexColumnWidth(3), // Principal
          2: FlexColumnWidth(3), // Email
          3: FlexColumnWidth(2), // Phone
          4: FlexColumnWidth(2), // Type
          5: FlexColumnWidth(1.6), // Actions
        },
        children: [
          _buildTableHeader(),
          ...schoolData.map((school) => _buildTableRow(school)).toList(),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return  const TableRow(
      children: [
        Padding(padding: EdgeInsets.all(12.0), child: Text('School Name', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Principal', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Type', style: TextStyle(fontWeight: FontWeight.bold))),
        Padding(padding: EdgeInsets.all(12.0), child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  TableRow _buildTableRow(Map<String, String> school) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.white),
      children: [
        Padding(padding: const EdgeInsets.all(12.0), child: Text(school['schoolName'] ?? 'N/A')),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(school['principalName'] ?? 'N/A')),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(school['principalEmail'] ?? 'N/A')),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(school['principalPhone'] ?? 'N/A')),
        Padding(padding: const EdgeInsets.all(12.0), child: Text(school['schoolType'] ?? 'N/A')),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeSchool(schoolData.indexOf(school)),
          ),
        ),
      ],
    );
  }
}
