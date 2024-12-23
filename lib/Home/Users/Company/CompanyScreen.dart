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
  // Sample data for 5 companies
  final List<Map<String, String>> companyData = [
    {
      "logo": "",
      "company_name": "ABC Pvt Ltd",
      "contact": "7741918243",
      "email": "info@abc.com",
      "industry": "Technology",
      "location": "Mumbai",
    },
    {
      "logo": "",
      "company_name": "XYZ Corp",
      "contact": "7741918244",
      "email": "contact@xyz.com",
      "industry": "Finance",
      "location": "Pune",
    },
    {
      "logo": "",
      "company_name": "Global Enterprises",
      "contact": "7741918245",
      "email": "admin@global.com",
      "industry": "Healthcare",
      "location": "Delhi",
    },
  ];

  void _removeCompany(int index) {
    setState(() {
      companyData.removeAt(index);
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
                    title: const Text('Company Dashboard'),
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                    child: _buildMainContent(constraints),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMainContent(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Tooltip(
                    message: 'Add a New Company',
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        "Add Company",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(3),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                    7: FlexColumnWidth(1.6),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.blueGrey.shade50),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Logo', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Company Name', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Industry', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Contact', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    ...companyData.map((company) => TableRow(
                      decoration: const BoxDecoration(color: Colors.white),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.business, size: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(company['company_name']!),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(company['industry']!),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(company['contact']!),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(company['location']!),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeCompany(companyData.indexOf(company)),
                        ),
                      ],
                    )),
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
