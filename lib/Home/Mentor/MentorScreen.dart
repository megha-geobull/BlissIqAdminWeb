import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({super.key});

  @override
  _MentorScreenState createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  // Sample data for 5 students
  final List<Map<String, String>> studentData = [
    {
      "profileImage": "",
      "user_name": "Student 10",
      "contact_no": "7741918243",
      "email": "student10@gmail.com",
      "school": "Nath High School Paithan",
      "std_class": "10th Class",
      "board_name": "SSC Board of Maharashtra",
      "language": "Marathi",
      "age_group": "19-25 years",
      "purpose": "Job",
      "score": "85",
    },
    {
      "profileImage": "",
      "user_name": "Student 11",
      "contact_no": "7741918244",
      "email": "student11@gmail.com",
      "school": "Nath High School Paithan",
      "std_class": "10th Class",
      "board_name": "SSC Board of Maharashtra",
      "language": "Marathi",
      "age_group": "19-25 years",
      "purpose": "Job",
      "score": "90",
    },
    {
      "profileImage": "",
      "user_name": "Student 12",
      "contact_no": "7741918245",
      "email": "student12@gmail.com",
      "school": "Nath High School Paithan",
      "std_class": "10th Class",
      "board_name": "SSC Board of Maharashtra",
      "language": "Marathi",
      "age_group": "19-25 years",
      "purpose": "Job",
      "score": "92",
    },
    {
      "profileImage": "",
      "user_name": "Student 13",
      "contact_no": "7741918246",
      "email": "student13@gmail.com",
      "school": "Nath High School Paithan",
      "std_class": "10th Class",
      "board_name": "SSC Board of Maharashtra",
      "language": "Marathi",
      "age_group": "19-25 years",
      "purpose": "Job",
      "score": "88",
    },
    {
      "profileImage": "",
      "user_name": "Student 14",
      "contact_no": "7741918247",
      "email": "student14@gmail.com",
      "school": "Nath High School Paithan",
      "std_class": "10th Class",
      "board_name": "SSC Board of Maharashtra",
      "language": "Marathi",
      "age_group": "19-25 years",
      "purpose": "Job",
      "score": "80",
    },
  ];

  void _removeStudent(int index) {
    setState(() {
      studentData.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Information'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(color: Colors.grey),
                  columnWidths: const {
                    0: FlexColumnWidth(2), // Profile
                    1: FlexColumnWidth(3), // Name
                    2: FlexColumnWidth(3), // Email
                    3: FlexColumnWidth(2), // Contact No
                    4: FlexColumnWidth(3), // School
                    5: FlexColumnWidth(2), // Class
                    6: FlexColumnWidth(2), // Board Name
                    7: FlexColumnWidth(2), // Language
                    8: FlexColumnWidth(2), // Age Group
                    9: FlexColumnWidth(2), // Purpose
                    10: FlexColumnWidth(1), // Score
                    11: FlexColumnWidth(1), // Actions
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Profile',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Contact No',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'School',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Class',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Board Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Language',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Age Group',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Purpose',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Score',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Actions',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ...studentData.map(
                          (student) {
                        int index = studentData.indexOf(student);
                        return TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(Icons.account_circle),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                student["user_name"] ?? 'No Name',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                student["email"] ?? 'No Email',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                student["contact_no"] ?? 'No Contact No',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                student["school"] ?? 'No School',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                student["std_class"] ?? 'No Class',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                student["board_name"] ?? 'No Board',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                student["language"] ?? 'No Language',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                student["age_group"] ?? 'No Age Group',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                student["purpose"] ?? 'No Purpose',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                student["score"] ?? 'No Score',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _removeStudent(index),
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
