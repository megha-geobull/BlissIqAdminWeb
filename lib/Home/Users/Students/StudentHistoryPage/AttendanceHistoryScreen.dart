import 'package:flutter/material.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildAttendanceTable(),
      ),
    );
  }

  Widget _buildAttendanceTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Attendance History",
          style: TextStyle(
            fontSize: 24,
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
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Status')),
                ],
                rows: List<DataRow>.generate(
                  10,
                      (index) => DataRow(cells: [
                    DataCell(Text('2024-12-${index + 1}')),
                    DataCell(Text('Student ${index + 1}')),
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
