import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/DashBoardEntrollmentController.dart';
import 'models/NotificationModel.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final TextEditingController notificationController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  String? selectedUser;
  String searchQuery = "";
  final List<String> users = [
    "Student",
    "Company",
    "Mentor",
    // "Teacher",
    "School"
  ];
  final DashBoardController controller = Get.put(DashBoardController());

  void _sendNotification() {
    if (selectedUser == null || notificationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please select a user and enter a notification message.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }else{
      controller.addNotification(title: titleController.text, notification: notificationController.text, userType: selectedUser!);
      // Add logic to send notification here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification sent to $selectedUser'),
          backgroundColor: Colors.green,
        ),
      );
      controller.getNotifications(userType: selectedUser!);
      notificationController.clear();
      titleController.clear();
      setState(() {
        selectedUser = null;
      });
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
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16),
                      child: Column(children: [
                        _buildMainContent(constraints),

                        _NotificationTable(constraints),
                      ],),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context,constraints) {
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
              'All Send Notifications',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Spacer(),
            Tooltip(
              message: 'Send Notifications',
              child: ElevatedButton.icon(
                onPressed: () {
                  showSendNotificationDialog(context,constraints);
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text("Send Notification",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BoxConstraints constraints) {
    return Center(
      child: _buildHeader(context,constraints),
    );
  }

  Widget _NotificationTable(BoxConstraints constraints) {
    List<NotificationData> filteredNotifications = controller.notifications
        .where((notification) =>
    notification.title!.toLowerCase().contains(searchQuery.toLowerCase()) ||
        notification.descriptions!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
    return Container(
        width: constraints.maxWidth * 0.6,
        height: constraints.maxWidth * 0.32,
        constraints: const BoxConstraints(
    ),child:  Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by title or description...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                 columnSpacing: 20.0,
                // headingRowHeight: 56.0,
                columns: const [
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: filteredNotifications.map((notification) {
                  return DataRow(cells: [
                    DataCell(Text(notification.title ?? '')),
                    DataCell(Text(notification.descriptions ?? '')),
                  DataCell(
                  IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => confirmDeleteNotification(notification.id ?? ''),
                  ),)
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ));
  }

  void confirmDeleteNotification(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this notification?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deleteNotification(id);
              Navigator.pop(context);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }

  void deleteNotification(String id) {
    controller.delete_notification(notificationID: id);
    setState(() {
      controller.notifications.removeWhere((item) => item.id == id);
    });
  }

 showSendNotificationDialog(BuildContext context,BoxConstraints constraints) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing on tap outside
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Send Notification',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: constraints.maxWidth * 0.4,
              height: constraints.maxWidth * 0.24,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select User Dropdown
                  Row(
                    children: [
                      Expanded(
                        child: Column(

                          children: [
                            const Text('Select User', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: selectedUser,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              hint: const Text('Choose a user', style: TextStyle(color: Colors.grey)),
                              items: users
                                  .map((user) => DropdownMenuItem(value: user, child: Text(user)))
                                  .toList(),
                              onChanged: (value) {
                                selectedUser = value;
                              },
                            ),
                            const SizedBox(height: 12),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      // Question Title Input
                      boxW10(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Question Title:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                labelText: 'Enter question title here...',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Notification Message Input
                  const Text('Notification Message:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: notificationController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Enter notification message",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close Dialog
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                _sendNotification();
                print("Sending notification to: $selectedUser");
                Navigator.pop(context);
              },
              child: const Text("Send Notification"),
            ),
          ],
        );
      },
    );
  }

}
