import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Home/Assign/AssignedMentorPage.dart';
import 'package:blissiqadmin/Home/Assign/AssignedStudentPage.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Models/AllSchoolModel.dart';
import 'package:blissiqadmin/Home/Users/School/SchoolRegistration.dart';
import 'package:blissiqadmin/auth/Controller/SchoolController/SchoolController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../Global/constants/CustomAlertDialogue.dart';

class SchoolScreen extends StatefulWidget {
  const SchoolScreen({super.key});

  @override
  _SchoolScreenState createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen> {
  final SchoolController schoolController = Get.put(SchoolController());
  Set<String> selectedSchoolIds = {};
  bool isSelectAll = false;
  List<Data> filteredSchoolData = [];
  Map<String, bool> editingStates = {}; // Track editing state for each row


  @override
  void initState() {
    super.initState();
    filteredSchoolData = schoolController.allSchoolData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      schoolController.getAllSchools();
      searchController.clear();
      _filterSchools(''); // Clear search on init
    });
  }

  void _toggleStatus(String schoolId) async {
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
      var school =
          schoolController.allSchoolData.where((p0) => p0.id == schoolId).first;

      schoolController.approveSchool(
        school_id: schoolId,
        approval_status: (school.approvalStatus == "Disapproved" ||
                school.approvalStatus == "Pending")
            ? "Approved"
            : "Disapproved",
      );
    }
  }

  // void onDelete(String title, String school_id) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => CustomAlertDialog(
  //       title: 'Are you sure',
  //       content: title,
  //       yesText: 'Yes',
  //       noText: 'No',
  //       onYesPressed: () {
  //         schoolController.delete_school(school_id);
  //         schoolController.getAllSchools();
  //         Navigator.pop(context);
  //         selectedSchoolIds.clear();
  //         setState(() {});
  //       },
  //     ),
  //   );
  // }

  void onDelete(String title, String school_id) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Are you sure',
        content: title,
        yesText: 'Yes',
        noText: 'No',
        onYesPressed: () {
          Navigator.pop(context);
          schoolController.delete_school(school_id).then((response) {
            setState(() {
              schoolController.getAllSchools();
              selectedSchoolIds.clear();
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('deleted successfully!')),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error occurred while deleting the company: $error')),
            );
          });
        },
      ),
    );
  }

  final TextEditingController searchController = TextEditingController();

  void _filterSchools(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSchoolData = schoolController.allSchoolData;
      } else {
        filteredSchoolData =
          schoolController.allSchoolData
              .where((school) => school.schoolName!
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
        return schoolController.isLoading.value
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
                            child: _buildSchoolMainContent(),
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

  Widget _buildSchoolMainContent() {
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
                    _filterSchools(value);
                  },
                ),
              ),
              boxW15(),
              if (selectedSchoolIds.isNotEmpty)
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
                    print("Selected Ids - ${selectedSchoolIds.join('|')}");
                    Future.delayed(const Duration(seconds: 1), () async {
                      onDelete("You want to delete this company?",
                          selectedSchoolIds.join('|'));
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
              child: schoolController.isLoading.value
                  ? Center(
                      child: LoadingAnimationWidget.hexagonDots(
                        color: Colors.deepOrange,
                        size: 70,
                      ),
                    )
                  : _buildSchoolDataTable()),
        ],
      ),
    );
  }

  Widget _buildSchoolDataTable() {
    if (filteredSchoolData.isEmpty) {
      return Center(
        child: Text(
          searchController.text.isEmpty
              ? "No schools available"
              : "No school found",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      );
    }
    return Card(
      elevation: 0.8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
        child: PaginatedDataTable(
          header: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Schools'),
            ],
          ),
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Contact No')),
            DataColumn(label: Text('Address')),
            DataColumn(label: Text('School Reg.no')),
            DataColumn(label: Text('School Type')),
            DataColumn(label: Text('Sponsor')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Mentor')),
            DataColumn(label: Text('Student')),
            DataColumn(label: Text('Actions')),
            DataColumn(label: Text('Edit')),
          ],
          source: SchoolDataTableSource(
            filteredSchoolData,
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
              'All Registered Schools',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Spacer(),
            Tooltip(
              message: 'Add a New School',
              child: ElevatedButton.icon(
                // onPressed: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => SchoolRegistration()),
                //   );
                // },
                onPressed: () {
                  Get.to( SchoolRegistration())?.then((value) {
                    if (value != null && value == true) {
                      setState(() {
                        print("Refresh!!!!");
                        schoolController.getAllSchools();
                      });
                    }
                  });
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text("Add School",
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

class SchoolDataTableSource extends DataTableSource {
  SchoolDataTableSource(this.schools, this.context, this.schoolScreenState) {
    buildDataTableRows();
  }

  final List<Data> schools;
  final BuildContext context;
  final _SchoolScreenState schoolScreenState;

  List<DataRow> dataTableRows = [];

  void buildDataTableRows() {
    dataTableRows = schools.map<DataRow>((dataRow) {
      final isEditing = schoolScreenState.editingStates[dataRow.id] ?? false;
      return DataRow(
        selected: schoolScreenState.selectedSchoolIds.contains(dataRow.id),
        onSelectChanged: (isSelected) {
          if (isSelected == true) {
            schoolScreenState.selectedSchoolIds.add(dataRow.id ?? '');
          } else {
            schoolScreenState.selectedSchoolIds.remove(dataRow.id ?? '');
          }
          schoolScreenState.setState(() {});
        },
        cells: [
          DataCell(
            isEditing
                ? TextFormField(
                    initialValue: dataRow.schoolName,
                    onChanged: (value) {
                      // dataRow.schoolName = value;
                    },
                  )
                : Text(dataRow.schoolName ?? 'No Name'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
                    initialValue: dataRow.principalEmail,
                    onChanged: (value) {
                      // dataRow.principalEmail = value;
                    },
                  )
                : Text(dataRow.principalEmail ?? 'No Email'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
                    initialValue: dataRow.principalPhone?.toString(),
                    onChanged: (value) {
                      // dataRow.principalPhone = value;
                    },
                  )
                : Text(dataRow.principalPhone?.toString() ?? '-'),
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
                    initialValue: dataRow.schoolRegNumber,
                    onChanged: (value) {
                      // dataRow.schoolRegNumber = value;
                    },
                  )
                : Text(dataRow.schoolRegNumber ?? 'No school reg.no'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
                    initialValue: dataRow.schoolType,
                    onChanged: (value) {
                      // dataRow.schoolType = value;
                    },
                  )
                : Text(dataRow.schoolType ?? 'no type'),
          ),
          DataCell(
            dataRow.companyId!.isNotEmpty
                ? ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 11),
                    ),
                    child: const Text('Sponsored',
                        style: TextStyle(fontSize: 12, color: Colors.white)),
                  )
                : const SizedBox.shrink(),
          ),
          DataCell(
            ElevatedButton(
              onPressed: () =>
                  schoolScreenState._toggleStatus(dataRow.id ?? ''),
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AssignedMentorPage(schoolID: dataRow.id ?? ''),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('View',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
          DataCell(
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AssignedStudentPage(schoolID: dataRow.id ?? ''),
                  ),
                );
              },
              style:
                  ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
              child: const Text('View',
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
          DataCell(
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                schoolScreenState.onDelete(
                  "You want to delete this school?",
                  dataRow.id!,
                );
              },
            ),
          ),
          DataCell(isEditing
              ? ElevatedButton(
                  onPressed: () {
                    // Save changes and exit edit mode
                    schoolScreenState.setState(() {
                      schoolScreenState.editingStates[dataRow.id!] = false;
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
                    schoolScreenState.setState(() {
                      schoolScreenState.editingStates[dataRow.id!] = true;
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
  int get selectedRowCount => schoolScreenState.selectedSchoolIds.length;
}
