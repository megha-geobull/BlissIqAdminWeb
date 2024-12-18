import 'package:flutter/material.dart';

import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/material.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  _AttendanceHistoryScreenState createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: LayoutBuilder(
        builder: (context, constraints) {
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
                    child: Center(child: _buildTopPerformersTable(constraints)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopPerformersTable(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Student Attendance Records",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                border: TableBorder.all(color: Colors.grey.shade300),
                columns: const [
                  DataColumn(label: Text('Rank')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Status')),
                ],
                rows: List<DataRow>.generate(
                  10,
                  (index) => DataRow(cells: [
                    DataCell(Text('#${index + 1}')),
                    DataCell(Text('Student ${index + 1}')),
                    DataCell(Text('2024-12-${index + 1}')),
                    DataCell(
                      Text(
                        index % 2 == 0 ? 'Present' : 'Absent',
                        style: TextStyle(
                          color: index % 2 == 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
