import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Mentor/MentorRegistration.dart';
import 'package:blissiqadmin/Home/Users/Models/GetAllMentorModel.dart';
import 'package:blissiqadmin/auth/Controller/AuthController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../Global/constants/CustomAlertDialogue.dart';

class MentorScreen extends StatefulWidget {
  const MentorScreen({super.key});

  @override
  _MentorScreenState createState() => _MentorScreenState();
}

class _MentorScreenState extends State<MentorScreen> {
  final AuthController mentorController = Get.put(AuthController());
  Set<String> selectedMentorIds = {};
  bool isSelectAll = false;
  List<Data> filteredMentorData = [];
  Map<String, bool> editingStates = {}; // Track editing state for each row
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMentorData = mentorController.allMentorData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mentorController.getAllMentors();
      searchController.clear();
      _filterMentors(''); // Clear search on init
    });
  }

  void _toggleStatus(String mentorId) async {
    bool? confirmation = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Action"),
          content: const Text("Are you sure you want to change the status?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("No", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Yes", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
    if (confirmation == true) {
      var mentor = mentorController.allMentorData
          .where((p0) => p0.sId == mentorId)
          .first;

      mentorController.approveMentors(
        mentor_id: mentorId,
        approval_status: (mentor.approvalStatus == "Disapproved" || mentor.approvalStatus == "Pending") ? "Approved" : "Disapproved",
      );
    }
  }

  void onDelete(String title, String mentor_id) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Are you sure',
        content: title,
        yesText: 'Yes',
        noText: 'No',
        onYesPressed: () {
          mentorController.delete_mentors(mentor_id);
          mentorController.getAllMentors();
          Navigator.pop(context);
          selectedMentorIds.clear();
          setState(() {});
        },
      ),
    );
  }

  void _filterMentors(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMentorData = mentorController.allMentorData;
      } else {
        filteredMentorData = mentorController.allMentorData
            .where((mentor) => mentor.fullName!
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        return mentorController.isLoading.value
            ? Center(
          child: LoadingAnimationWidget.hexagonDots(
            color: Colors.deepOrange,
            size: 70,
          ),
        )
            : LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 800;
            return Row(
              children: [
                if (isWideScreen)
                  Container(
                    width: 250,
                    color: Colors.orange.shade100,
                    child: const MyDrawer(),
                  ),
                Expanded(
                  child: Scaffold(
                    appBar: isWideScreen
                        ? null
                        : AppBar(
                      title: const Text('Dashboard'),
                      backgroundColor: Colors.blue.shade100,
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16),
                      child: _buildMentorMainContent(),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  Widget _buildMentorMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          boxH15(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    _filterMentors(value);
                  },
                ),
              ),
              boxW15(),
              if (selectedMentorIds.isNotEmpty)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 19, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () async {
                    print("Selected Ids - ${selectedMentorIds.join('|')}");
                    Future.delayed(const Duration(seconds: 1), () async {
                      onDelete("You want to delete this mentor?",
                          selectedMentorIds.join('|'));
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
              child: mentorController.isLoading.value
                  ? Center(
                child: LoadingAnimationWidget.hexagonDots(
                  color: Colors.deepOrange,
                  size: 70,
                ),
              )
                  : _buildMentorDataTable()),
        ],
      ),
    );
  }

  Widget _buildMentorDataTable() {
    return Card(
      elevation: 0.8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
        child: PaginatedDataTable(
          header: const Row(
            children: [
              Text('Mentors'),
            ],
          ),
          columns: const [
            DataColumn(label: Text('Profile')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Contact No')),
            DataColumn(label: Text('Address')),
            DataColumn(label: Text('Experience')),
            DataColumn(label: Text('Qualification')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
            DataColumn(label: Text('Edit')),
          ],
          source: MentorDataTableSource(
            filteredMentorData,
            context,
            this,
          ),
          rowsPerPage: 10,
          showFirstLastButtons: true,
        ),
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
              'All Registered Mentors',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Spacer(),
            Tooltip(
              message: 'Add a New Mentor',
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MentorRegistration()),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text("Add Mentor",
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
}

class MentorDataTableSource extends DataTableSource {
  MentorDataTableSource(this.mentors, this.context, this.mentorScreenState) {
    buildDataTableRows();
  }

  final List<Data> mentors;
  final BuildContext context;
  final _MentorScreenState mentorScreenState;

  List<DataRow> dataTableRows = [];

  void buildDataTableRows() {
    dataTableRows = mentors.map<DataRow>((dataRow) {
      final isEditing = mentorScreenState.editingStates[dataRow.sId] ?? false;
      return DataRow(
        selected: mentorScreenState.selectedMentorIds.contains(dataRow.sId),
        onSelectChanged: (isSelected) {
          if (isSelected == true) {
            mentorScreenState.selectedMentorIds.add(dataRow.sId ?? '');
          } else {
            mentorScreenState.selectedMentorIds.remove(dataRow.sId ?? '');
          }
          mentorScreenState.setState(() {});
        },
        cells: [
          DataCell(
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: CachedNetworkImage(
                imageUrl: ApiString.ImgBaseUrl + (dataRow.profileImage ?? ''),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.fullName,
              onChanged: (value) {
                // dataRow.fullName = value;
              },
            )
                : Text(dataRow.fullName ?? 'No Name'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.email,
              onChanged: (value) {
                // dataRow.email = value;
              },
            )
                : Text(dataRow.email ?? 'No Email'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.contactNo?.toString(),
              onChanged: (value) {
                // dataRow.contactNo = value;
              },
            )
                : Text(dataRow.contactNo?.toString() ?? '-'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.address,
              onChanged: (value) {
                // dataRow.address = value;
              },
            )
                : Text(dataRow.address ?? 'No Address'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.experience,
              onChanged: (value) {
                // dataRow.experience = value;
              },
            )
                : Text(dataRow.experience ?? 'No experience'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.qualification,
              onChanged: (value) {
                // dataRow.qualification = value;
              },
            )
                : Text(dataRow.qualification ?? 'No qualification'),
          ),
          DataCell(
            ElevatedButton(
              onPressed: () =>
                  mentorScreenState._toggleStatus(dataRow.sId ?? ''),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: _getButtonColor(dataRow.approvalStatus),
              ),
              child: Text(
                dataRow.approvalStatus ?? 'Pending',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          DataCell(
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                mentorScreenState.onDelete(
                  "You want to delete this mentor?",
                  dataRow.sId!,
                );
              },
            ),
          ),
          DataCell(isEditing
              ? ElevatedButton(
            onPressed: () {
              // Save changes and exit edit mode
              mentorScreenState.setState(() {
                mentorScreenState.editingStates[dataRow.sId!] = false;
              });
              // Call update API here if needed
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Update'),
          )
              : ElevatedButton(
            onPressed: () {
              // Save changes and exit edit mode
              mentorScreenState.setState(() {
                mentorScreenState.editingStates[dataRow.sId!] = true;
              });
              // Call update API here if needed
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Edit'),
          )),
        ],
      );
    }).toList();
  }

  Color _getButtonColor(String? approvalStatus) {
    switch (approvalStatus) {
      case "Approved":
        return AppColor.green;
      case "Disapproved":
        return AppColor.red;
      case "Pending":
        return AppColor.amber;
      default:
        return AppColor.grey;
    }
  }

  @override
  DataRow? getRow(int index) => dataTableRows[index];

  @override
  int get rowCount => dataTableRows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => mentorScreenState.selectedMentorIds.length;
}