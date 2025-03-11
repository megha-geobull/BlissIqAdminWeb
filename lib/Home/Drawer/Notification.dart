
import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/DashBoardEntrollmentController.dart';
import 'models/NotificationModel.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final TextEditingController notificationController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  Set<String> selectedStudentIds = {};

  String? selectedUser;
  String searchQuery = "";
  final List<String> users = ["Student", "Company", "Mentor", "School"];
  final DashBoardController controller = Get.put(DashBoardController());

  List<NotificationData> newFilteredNotifications = [];
  Set<String> selectedNotificationIds = {};
  late NotificationDataTableSource dataTableSource;

  @override
  void initState() {
    super.initState();
    dataTableSource = NotificationDataTableSource(
      controller.filteredNotifications,
      context,
      deleteNotification,
      this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getNotifications(userType: selectedUser ?? "Student");
      searchController.clear();
    });
    controller.filteredNotifications = controller.notifications;
  }

  void _sendNotification() async {
    if (selectedUser == null || notificationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a user and enter a notification message.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Send notification asynchronously
    await controller.addNotification(
      title: titleController.text,
      notification: notificationController.text,
      userType: selectedUser.toString(),
    );

    // Fetch the updated notification list
    await controller.getNotifications(userType: selectedUser.toString());

    // Update the UI
    setState(() {
      controller.filteredNotifications = controller.notifications;
      notificationController.clear();
      titleController.clear();
      dataTableSource.updateData(controller.filteredNotifications);
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification sent to $selectedUser'),
        backgroundColor: Colors.green,
      ),
    );

    Get.back();
  }

  void _filterNotifications(String query) {
    setState(() {
      if (query.isEmpty) {
        controller.filteredNotifications.value = controller.notifications;
      } else {
        controller.filteredNotifications.value = controller.notifications
            .where((student) => student.title.toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
  }


  void confirmDeleteNotification(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this notification?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deleteNotification(id);
              Navigator.pop(context);
            },
            child: const Text("Yes"),
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

  @override
  void didUpdateWidget(covariant NotificationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      controller.filteredNotifications = controller.notifications;
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
                    backgroundColor: Colors.blue.shade100,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  drawer: isWideScreen ? null : Drawer(child: MyDrawer()),
                  body: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: constraints.maxWidth * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: _buildHeader(context, constraints)),
                              const SizedBox(height: 20),
                              _buildSearchBar(context, constraints),
                              const SizedBox(height: 20),
                              _buildNotificationTable(context, constraints),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildHeader(BuildContext context, BoxConstraints constraints) {
    return Card(
      elevation: 0.8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Text(
              'All Sent Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => showSendNotificationDialog(context, constraints),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Send Notification",style:  TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth * 0.4,
      child: Card(
        elevation: 0.8,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by title',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: _filterNotifications,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationTable(BuildContext context, BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth * 0.6,
      child: Card(
        elevation: 0.8,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: PaginatedDataTable(
              columns: const [
                DataColumn(label: Text('Title')),
                DataColumn(label: Text('Message')),
                DataColumn(label: Text('Actions')),
              ],
              source: NotificationDataTableSource(
                controller.filteredNotifications, // Keep only reactive state access
                context,
                deleteNotification,
                this,
              ),
              rowsPerPage: 10,
              showFirstLastButtons: true,
            ),

        ),
      ),
    );
  }

  void showSendNotificationDialog(BuildContext context, BoxConstraints constraints) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Send Notification', style: TextStyle(fontSize: 18)),
          content: SizedBox(
            width: constraints.maxWidth * 0.4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedUser,
                  decoration: InputDecoration(
                    labelText: 'Select User',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ), items: users.map((user) => DropdownMenuItem(
                  value: user,
                  child: Text(user),
                )).toList(),onChanged: (value) => setState(() => selectedUser = value),),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Question Title',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notificationController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notification Message',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _sendNotification,
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}


class NotificationDataTableSource extends DataTableSource {
  final List<NotificationData> filteredNotifications;
  final BuildContext context;
  final Function(String) deleteNotification;
  final _NotificationPageState notificationPageState;

  List<DataRow> dataTableRows = [];

  NotificationDataTableSource(
      this.filteredNotifications,
      this.context,
      this.deleteNotification,
      this.notificationPageState,
      ) {
    buildDataTableRows();
  }

  void buildDataTableRows() {
    dataTableRows = filteredNotifications.map<DataRow>((dataRow) {
      return DataRow(
        selected: notificationPageState.selectedStudentIds.contains(dataRow.id),
        onSelectChanged: (isSelected) {
          if (isSelected == true) {
            notificationPageState.selectedStudentIds.add(dataRow.id ?? '');
          } else {
            notificationPageState.selectedStudentIds.remove(dataRow.id ?? '');
          }
          notificationPageState.setState(() {});
        },
        cells: [
          DataCell(
            Text(dataRow.title ?? 'No title'),
          ),
          DataCell(
            Text(dataRow.descriptions ?? 'No descriptions'),
          ),
          DataCell(
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                deleteNotification(dataRow.id.toString());
              },
            ),
          ),
        ],
      );
    }).toList();
  }

  /// Method to rebuild the data table when data changes
  void updateData(List<NotificationData> newNotifications) {
    filteredNotifications.clear();
    filteredNotifications.addAll(newNotifications);
    buildDataTableRows(); // Rebuild the table rows
    notifyListeners(); // Notify listeners that data has changed
  }

  @override
  DataRow? getRow(int index) {
    if (index >= 0 && index < dataTableRows.length) {
      return dataTableRows[index];
    }
    return null; // Avoid index out of range error
  }

  @override
  int get rowCount => filteredNotifications.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => notificationPageState.selectedStudentIds.length;
}
