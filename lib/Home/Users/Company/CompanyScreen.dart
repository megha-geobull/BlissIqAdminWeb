import 'dart:io';

import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  // Sample data for 5 students
  final List<Map<String, String>> companyData = [
    {
      "profileImage": "",
      "user_name": "Company 1",
      "contact_no": "7741918243",
      "email": "Company@gmail.com",
      "status": "Approve",
    },
    {
      "profileImage": "",
      "user_name": "Company 2",
      "contact_no": "7741918244",
      "email": "Company@gmail.com",
      "status": "Disapprove",
    },

    {
      "profileImage": "",
      "user_name": "Company 3",
      "contact_no": "7741918245",
      "email": "Company@gmail.com",
      "status": "Disapprove",
    },
    {
      "profileImage": "",
      "user_name": "Company 4",
      "contact_no": "7741918246",
      "email": "Company@gmail.com",
      "status": "Disapprove",
    },
    {
      "profileImage": "",
      "user_name": "Company 5",
      "contact_no": "7741918247",
      "email": "Company@gmail.com",
      "status": "Disapprove",
    },
  ];

  void _toggleStatus(int index) async {
    bool? confirmation = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Action"),
          content: const Text("Are you sure you want to change the status?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );

    if (confirmation == true) {
      setState(() {
        companyData[index]["status"] = companyData[index]["status"] == "Approve" ? "Disapprove" : "Approve";
      });
    }
  }

  void _removeStudent(int index) {
    setState(() {
      companyData.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check screen size for responsiveness
          bool isWideScreen = constraints.maxWidth > 800;

          return Row(
            children: [
              // Always visible drawer for wide screens
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
                        icon: const Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          // Handle notifications
                        },
                      ),
                    ],
                  ),
                  drawer: isWideScreen ? null : Drawer(child: MyDrawer()),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: _buildMentorMainContent(constraints),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMentorMainContent(BoxConstraints constraints) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white,
                )),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text(
                    'All Registered Companies',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Tooltip(
                    message: 'Add a New Company',
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        "Add Company",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Table(
                  border: const TableBorder.symmetric(
                    inside: BorderSide(color: Colors.grey, width: 0.5),
                    outside: BorderSide.none,
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(2), // Profile
                    1: FlexColumnWidth(2), // Name
                    2: FlexColumnWidth(3), // Email
                    3: FlexColumnWidth(2), // Contact No// Score
                    4: FlexColumnWidth(2), // Status
                    5: FlexColumnWidth(1.6), // Actions
                    6: FlexColumnWidth(2), // Details
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Profile',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Contact No',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Details',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Actions',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ...companyData.map(
                          (company) {
                        int index = companyData.indexOf(company);
                        return TableRow(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          children: [

                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(Icons.account_circle, size: 20),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                company["user_name"] ?? 'No Name',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                company["email"] ?? 'No Email',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                company["contact_no"] ?? 'No Contact No',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ElevatedButton(
                                onPressed: () => _toggleStatus(index),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  backgroundColor: company["status"] == "Approve"
                                      ? Colors.green
                                      : Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 9),
                                ),
                                child: Text(
                                  company["status"] ?? "Disapprove",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    "View",
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: IconButton(
                                icon:
                                const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeStudent(index),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}













