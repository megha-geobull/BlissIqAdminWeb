import 'package:flutter/material.dart';

import 'dart:io';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TopPerformerStudents extends StatefulWidget {
  const TopPerformerStudents({super.key});

  @override
  State<TopPerformerStudents> createState() => _TopPerformerStudentsState();
}

class _TopPerformerStudentsState extends State<TopPerformerStudents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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

                              },
                            ),
                          ],
                        ),
                  drawer: isWideScreen ? null : Drawer(child: MyDrawer()),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child:
                        Center(child: _buildTopPerformerContent(constraints)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopPerformerContent(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Top Performing Students",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
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
                    DataColumn(label: Text('Score')),
                    DataColumn(label: Text('Grade')),
                  ],
                  rows: List<DataRow>.generate(
                    10,
                    (index) => DataRow(cells: [
                      DataCell(Text(
                        '#${index + 1}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataCell(Text('Student ${index + 1}')),
                      DataCell(Text(
                        '${90 + index}',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      DataCell(Text(
                        'A',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
