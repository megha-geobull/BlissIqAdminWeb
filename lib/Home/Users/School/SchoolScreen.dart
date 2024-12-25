
import 'dart:io';

import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Mentor/MentorListBottomSheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  _SchoolScreenState createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  // Sample data for 5 students
  final List<Map<String, String>> studentData = [
    {
      "profileImage": "",
      "user_name": "School 10",
      "contact_no": "7741918243",
      "email": "student10@gmail.com",
      "school": "Nath High School Paithan",
      "board_name": "SSC Board of Maharashtra",
      "status": "Approve",
    },
    {
      "profileImage": "",
      "user_name": "School 11",
      "contact_no": "7741918244",
      "email": "student11@gmail.com",
      "school": "Nath High School Paithan",
      "board_name": "SSC Board of Maharashtra",
      "status": "Disapprove",
    },
    {
      "profileImage": "",
      "user_name": "School 12",
      "contact_no": "7741918245",
      "email": "student12@gmail.com",
      "school": "Nath High School Paithan",
      "board_name": "SSC Board of Maharashtra",
      "status": "Approve",
    },
    {
      "profileImage": "",
      "user_name": "School 13",
      "contact_no": "7741918246",
      "email": "student13@gmail.com",
      "school": "Nath High School Paithan",
      "board_name": "SSC Board of Maharashtra",
      "status": "Disapprove",
    },
    {
      "profileImage": "",
      "user_name": "School 14",
      "contact_no": "7741918247",
      "email": "student14@gmail.com",
      "school": "Nath High School Paithan",
      "board_name": "SSC Board of Maharashtra",
      "status": "Approve",
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
        studentData[index]["status"] =
        studentData[index]["status"] == "Approve" ? "Disapprove" : "Approve";
      });
    }
  }

  void _removeStudent(int index) {
    setState(() {
      studentData.removeAt(index);
    });
  }

  void _showMentorBottomSheet(BuildContext context) async {
    String? selectedMentor = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return MentorListBottomSheet();
      },
    );

    if (selectedMentor != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Assigned to $selectedMentor')),
      );
    }
  }


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
                    'All Registered School',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Tooltip(
                    message: 'Add a New School',
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        "Add School",
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
                    3: FlexColumnWidth(2), // Contact No
                    4: FlexColumnWidth(3), // School
                    7: FlexColumnWidth(2), // Status
                    8: FlexColumnWidth(2), // Assign
                    9: FlexColumnWidth(1.6), // Actions
                    10: FlexColumnWidth(2), // Details
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
                            'School',
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
                            'Assign',
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
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Details',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ...studentData.map(
                          (student) {
                        int index = studentData.indexOf(student);
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
                                student["user_name"] ?? 'No Name',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                student["email"] ?? 'No Email',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                student["contact_no"] ?? 'No Contact No',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                student["school"] ?? 'No School',
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
                                  backgroundColor: student["status"] == "Approve"
                                      ? Colors.green
                                      : Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 9),
                                ),
                                child: Text(
                                  student["status"] ?? "Disapprove",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 9),
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Assign logic
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange, // Set the background color to green
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero, // Makes the button rectangular
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), // Adjust padding if needed
                                ),
                                child: const Text(
                                  'Assign',
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // White text color for contrast
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


//
// import 'dart:io';
//
// import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// class SchoolScreen extends StatefulWidget {
//   const SchoolScreen({super.key});
//
//   @override
//   _SchoolScreenState createState() => _SchoolScreenState();
// }
//
// class _SchoolScreenState extends State<SchoolScreen> {
//   // Sample data for 5 students
//   final List<Map<String, String>> studentData = [
//     {
//       "profileImage": "",
//       "user_name": "Student 10",
//       "contact_no": "7741918243",
//       "email": "student10@gmail.com",
//       "school": "Nath High School Paithan",
//       "std_class": "10th Class",
//       "board_name": "SSC Board of Maharashtra",
//       "language": "Marathi",
//       "age_group": "19-25 years",
//       "purpose": "Job",
//       "score": "85",
//       "status": "Approve",
//     },
//     {
//       "profileImage": "",
//       "user_name": "Student 11",
//       "contact_no": "7741918244",
//       "email": "student11@gmail.com",
//       "school": "Nath High School Paithan",
//       "std_class": "10th Class",
//       "board_name": "SSC Board of Maharashtra",
//       "language": "Marathi",
//       "age_group": "19-25 years",
//       "purpose": "Job",
//       "score": "90",
//       "status": "Disapprove",
//     },
//     {
//       "profileImage": "",
//       "user_name": "Student 12",
//       "contact_no": "7741918245",
//       "email": "student12@gmail.com",
//       "school": "Nath High School Paithan",
//       "std_class": "10th Class",
//       "board_name": "SSC Board of Maharashtra",
//       "language": "Marathi",
//       "age_group": "19-25 years",
//       "purpose": "Job",
//       "score": "92",
//       "status": "Approve",
//     },
//     {
//       "profileImage": "",
//       "user_name": "Student 13",
//       "contact_no": "7741918246",
//       "email": "student13@gmail.com",
//       "school": "Nath High School Paithan",
//       "std_class": "10th Class",
//       "board_name": "SSC Board of Maharashtra",
//       "language": "Marathi",
//       "age_group": "19-25 years",
//       "purpose": "Job",
//       "score": "88",
//       "status": "Disapprove",
//     },
//     {
//       "profileImage": "",
//       "user_name": "Student 14",
//       "contact_no": "7741918247",
//       "email": "student14@gmail.com",
//       "school": "Nath High School Paithan",
//       "std_class": "10th Class",
//       "board_name": "SSC Board of Maharashtra",
//       "language": "Marathi",
//       "age_group": "19-25 years",
//       "purpose": "Job",
//       "score": "80",
//       "status": "Approve",
//     },
//   ];
//
//   void _toggleStatus(int index) async {
//     bool? confirmation = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Confirm Action"),
//           content: const Text("Are you sure you want to change the status?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text("No", style: TextStyle(color: Colors.red)),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: const Text("Yes", style: TextStyle(color: Colors.green)),
//             ),
//           ],
//         );
//       },
//     );
//
//     if (confirmation == true) {
//       setState(() {
//         studentData[index]["status"] =
//         studentData[index]["status"] == "Approve" ? "Disapprove" : "Approve";
//       });
//     }
//   }
//
//   void _removeStudent(int index) {
//     setState(() {
//       studentData.removeAt(index);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           // Check screen size for responsiveness
//           bool isWideScreen = constraints.maxWidth > 800;
//
//           return Row(
//             children: [
//               // Always visible drawer for wide screens
//               if (isWideScreen)
//                 Container(
//                   width: 250,
//                   color: Colors.orange.shade100,
//                   child: MyDrawer(),
//                 ),
//               Expanded(
//                 child: Scaffold(
//                   appBar: isWideScreen
//                       ? null
//                       : AppBar(
//                     title: const Text('Dashboard'),
//                     scrolledUnderElevation: 0,
//                     backgroundColor: Colors.blue.shade100,
//                     actions: [
//                       IconButton(
//                         icon: const Icon(
//                           Icons.person,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           // Handle notifications
//                         },
//                       ),
//                     ],
//                   ),
//                   drawer: isWideScreen ? null : Drawer(child: MyDrawer()),
//                   body: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8.0, vertical: 16),
//                     child: _buildMentorMainContent(constraints),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildMentorMainContent(BoxConstraints constraints) {
//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//                 color: Colors.orange.shade100,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(
//                   color: Colors.white,
//                 )),
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   const Text(
//                     'All Registered Students',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const Spacer(),
//                   Tooltip(
//                     message: 'Add a New Student',
//                     child: ElevatedButton.icon(
//                       onPressed: () {},
//                       icon: const Icon(
//                         Icons.add,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                       label: const Text(
//                         "Add Student",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.deepOrange,
//                         elevation: 3,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Card(
//                 elevation: 3,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Table(
//                   border: const TableBorder.symmetric(
//                     inside: BorderSide(color: Colors.grey, width: 0.5),
//                     outside: BorderSide.none,
//                   ),
//                   columnWidths: const {
//                     0: FlexColumnWidth(2), // Profile
//                     1: FlexColumnWidth(2), // Name
//                     2: FlexColumnWidth(3), // Email
//                     3: FlexColumnWidth(2), // Contact No
//                     4: FlexColumnWidth(3), // School
//                     5: FlexColumnWidth(2), // Class
//                     6: FlexColumnWidth(1.4), // Score
//                     7: FlexColumnWidth(2), // Status
//                     8: FlexColumnWidth(2), // Assign
//                     9: FlexColumnWidth(1.6), // Actions
//                     10: FlexColumnWidth(2), // Details
//                   },
//                   children: [
//                     TableRow(
//                       decoration: BoxDecoration(
//                         color: Colors.blueGrey.shade50,
//                         borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(8),
//                         ),
//                       ),
//                       children: const [
//                         Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Text(
//                             'Profile',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Text(
//                             'Name',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Text(
//                             'Email',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Text(
//                             'Contact No',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Text(
//                             'School',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Text(
//                             'Class',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Text(
//                             'Score',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Text(
//                             'Status',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//
//                         Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Text(
//                             'Assign',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//
//                         Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Text(
//                             'Actions',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Text(
//                             'Details',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                     ...studentData.map(
//                           (student) {
//                         int index = studentData.indexOf(student);
//                         return TableRow(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                           ),
//                           children: [
//                             const Padding(
//                               padding: EdgeInsets.all(12.0),
//                               child: Icon(Icons.account_circle, size: 20),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Text(
//                                 student["user_name"] ?? 'No Name',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Text(
//                                 student["email"] ?? 'No Email',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Text(
//                                 student["contact_no"] ?? 'No Contact No',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Text(
//                                 student["school"] ?? 'No School',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Text(
//                                 student["std_class"] ?? 'No Class',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Text(
//                                 student["score"] ?? 'No Score',
//                                 style: const TextStyle(fontSize: 14),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: ElevatedButton(
//                                 onPressed: () => _toggleStatus(index),
//                                 style: ElevatedButton.styleFrom(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   backgroundColor: student["status"] == "Approve"
//                                       ? Colors.green
//                                       : Colors.red,
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 7, vertical: 9),
//                                 ),
//                                 child: Text(
//                                   student["status"] ?? "Disapprove",
//                                   style: const TextStyle(
//                                       color: Colors.white, fontSize: 9),
//                                 ),
//                               ),
//                             ),
//
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   // Assign logic
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.orange, // Set the background color to green
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.zero, // Makes the button rectangular
//                                   ),
//                                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), // Adjust padding if needed
//                                 ),
//                                 child: const Text(
//                                   'Assign',
//                                   style: TextStyle(
//                                     letterSpacing: 1,
//                                     fontSize: 8,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black, // White text color for contrast
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//
//
//
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: IconButton(
//                                 icon:
//                                 const Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () => _removeStudent(index),
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.all(12.0),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.orange,
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: TextButton(
//                                   onPressed: () {},
//                                   child: const Text(
//                                     "View",
//                                     style: TextStyle(
//                                       letterSpacing: 1,
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//

