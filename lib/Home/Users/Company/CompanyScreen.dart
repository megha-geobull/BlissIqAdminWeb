import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomAlertDialogue.dart';
import 'package:blissiqadmin/Home/Assign/AssignedSchoolPage.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Company/CompanyRegistrationPage.dart';
import 'package:blissiqadmin/Home/Users/Company/CompnayListBottomSheet.dart';
import 'package:blissiqadmin/Home/Users/Models/GetAllCompanyModel.dart';
import 'package:blissiqadmin/auth/Controller/CompanyController/CompanyController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final CompanyController companyController = Get.put(CompanyController());
  Set<String> selectedCompanyIds = {};
  bool isSelectAll = false;
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  final _verticalScrollController = ScrollController();
  Map<String, bool> editingStates = {}; // Track editing state for each row
  List<Data> filteredCompanyData = [];

  @override
  void initState() {
    super.initState();
    filteredCompanyData = companyController.allCompanyData;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      companyController.getAllCompany();
      searchController.clear();
      _filterSchools('');
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
      var school = companyController.allCompanyData
          .where((p0) => p0.id == schoolId)
          .first;

      companyController.approveCompany(
        companyID: schoolId,
        approvalStatus: (school.approvalStatus == "Disapproved" ||
            school.approvalStatus == "Pending")
            ? "Approved"
            : "Disapproved",
      );
    }
  }

  void _showSchoolBottomSheet(BuildContext context, String? id) async {
    var selectedSchool = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        String? companyID = id;
        return CompnayListBottomSheet(companyID);
      },
    );
    if (selectedSchool != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Assigned to $selectedSchool')),
      );
    }
  }

  void onDelete(String title, String companyId) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Are you sure',
        content: title,
        yesText: 'Yes',
        noText: 'No',
        onYesPressed: () {
          Navigator.pop(context);
          companyController.delete_company(companyId);
          companyController.getAllCompany();
          setState(() {});
        },
      ),
    );
  }

  final TextEditingController searchController = TextEditingController();

  void _filterSchools(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCompanyData = companyController.allCompanyData;
      } else {
        filteredCompanyData =
          companyController.allCompanyData.where(
                (company) =>
            (company.companyName?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
                (company.ownerName?.toLowerCase().contains(query.toLowerCase()) ?? false),
          ).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Obx(() {
        if (companyController.isLoading.value) {
          return Center(
            child: LoadingAnimationWidget.hexagonDots(
              color: Colors.deepOrange,
              size: 70,
            ),
          );
        } else {
          return LayoutBuilder(
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
        }
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
              if (selectedCompanyIds.isNotEmpty)
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
                    print("Selected Ids - $selectedCompanyIds");
                    Future.delayed(const Duration(seconds: 1), () async {
                      onDelete("You want to delete this company?",
                          selectedCompanyIds.join('|'));
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
          companyController.allCompanyData.isEmpty && filteredCompanyData.isEmpty
              ? Center(child: Text('No Data Available'))
              : Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Scrollbar(
                thumbVisibility: true,
                controller: _verticalScrollController,
                child: SingleChildScrollView(
                  controller: _verticalScrollController,
                  child: PaginatedDataTable(
                    headingRowHeight: 48,
                    columnSpacing: 20,
                    horizontalMargin: 16,
                    rowsPerPage: _rowsPerPage,
                    onRowsPerPageChanged: (value) {
                      setState(() {
                        _rowsPerPage = value!;
                      });
                    },
                    dataRowHeight: 72,
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Companies'),
                        Row(
                          children: [
                            Checkbox(
                              value: isSelectAll,
                              onChanged: (value) {
                                setState(() {
                                  isSelectAll = value ?? false;
                                  if (isSelectAll) {
                                    selectedCompanyIds.addAll(
                                      filteredCompanyData.map((e) => e.id ?? ''),
                                    );
                                  } else {
                                    selectedCompanyIds.clear();
                                  }
                                });
                              },
                            ),
                            const Text('Select All'),
                          ],
                        ),
                      ],
                    ),
                    columns: [
                      DataColumn(label: Text("Profile")),
                      DataColumn(label: Text("Owner Name")),
                      DataColumn(label: Text("Company Name")),
                      DataColumn(label: Text("Email")),
                      DataColumn(label: Text("Contact No")),
                      DataColumn(label: Text("GST No")),
                      DataColumn(label: Text("CIN Number")),
                      DataColumn(label: Text("Pan Card No")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("School")),
                      DataColumn(label: Text("Assign")),
                      DataColumn(label: Text("Action")),
                      DataColumn(label: Text("Edit")),
                    ],
                    source: CompanyTableSource(filteredCompanyData, this,context),
                  ),
                ),
              ),
            ),
          ),
        ],
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
              'All Registered Companies',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            const Spacer(),
            Tooltip(
              message: 'Add a New Company',
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompanyRegistrationPage()),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                label: const Text("Add Company",
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

class CompanyTableSource extends DataTableSource {
  CompanyTableSource(
      this.company,
      this.companyScreenState,
      this.context
      ){
    buildDataTableRows();
  }
  final List<Data> company;
  final BuildContext context;
  final _CompanyScreenState companyScreenState;
  List<DataRow> dataTableRows = [];

  List<PlatformFile>? _paths;
  var pathsFile;
  var pathsFileName;
  bool isFilePicked = false;
  List<PlatformFile>? _panPaths;
  var panPathsFile;
  var panPathsFileName;
  pickFile(String fileType) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      onFileLoading: (FilePickerStatus status) => print("status .... $status"),
      allowedExtensions: [
        'bmp',
        'dib',
        'gif',
        'jfif',
        'jpe',
        'jpg',
        'jpeg',
        'pbm',
        'pgm',
        'ppm',
        'pnm',
        'pfm',
        'png',
        'apng',
        'blp',
        'bufr',
        'cur',
        'pcx',
        'dcx',
        'dds',
        'ps',
        'eps',
        'fit',
        'fits',
        'fli',
        'flc',
        'ftc',
        'ftu',
        'gbr',
        'grib',
        'h5',
        'hdf',
        'jp2',
        'j2k',
        'jpc',
        'jpf',
        'jpx',
        'j2c',
        'icns',
        'ico',
        'im',
        'iim',
        'mpg',
        'mpeg',
        'tif',
        'tiff',
        'mpo',
        'msp',
        'palm',
        'pcd',
        'pdf',
        'pxr',
        'psd',
        'qoi',
        'bw',
        'rgb',
        'rgba',
        'sgi',
        'ras',
        'tga',
        'icb',
        'vda',
        'vst',
        'webp',
        'wmf',
        'emf',
        'xbm',
        'xpm'
      ],
    );

    if (result != null && result.files.isNotEmpty) {
      if(fileType == 'profile')
        {
          _paths = result.files;
          pathsFile = _paths!.first.bytes; // Store the bytes
          pathsFileName = _paths!.first.name; // Store the file name
          isFilePicked = true;
          notifyListeners();
        }
      else{
        _panPaths = result.files;
        panPathsFile = _paths!.first.bytes; // Store the bytes
        panPathsFileName = _paths!.first.name; // Store the file name
        isFilePicked = true;
        notifyListeners();
      }
    } else {
      print('No file selected');
    }
  }
  void buildDataTableRows() {
    dataTableRows = company.map<DataRow>((dataRow) {
      final isEditing = companyScreenState.editingStates[dataRow.id] ?? false;
      return DataRow(
        selected: companyScreenState.selectedCompanyIds.contains(dataRow.id),
        onSelectChanged: (isSelected) {
          if (isSelected == true) {
            companyScreenState.selectedCompanyIds.add(dataRow.id ?? '');
          } else {
            companyScreenState.selectedCompanyIds.remove(dataRow.id ?? '');
          }
          companyScreenState.setState(() {});
        },
        cells: [
          DataCell(
      isEditing ? SizedBox(
        width: 50,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: isFilePicked ? Colors.green : Colors.blue, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: Icon(Icons.image, color: isFilePicked ? Colors.green :Colors.blue),
            onPressed: () => pickFile('profile'),
          ),
        ),
      ) :
            dataRow.profilePic != null
                ? SizedBox(
              width: 50,
              child: CachedNetworkImage(
                imageUrl: ApiString.ImgBaseUrl + dataRow.profilePic!,
                progressIndicatorBuilder:
                    (context, url, downloadProgress) =>
                    CircularProgressIndicator(
                        value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            )
                : const SizedBox.shrink(),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.ownerName,
              onChanged: (value) {
                // dataRow.principalEmail = value;
              },
            )
                : Text(dataRow.ownerName ?? 'No name'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.companyName?.toString(),
              onChanged: (value) {
                // dataRow.principalPhone = value;
              },
            )
                : Text(dataRow.companyName?.toString() ?? '-'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.email,
              onChanged: (value) {
                // dataRow.address = value;
              },
            )
                : Text(dataRow.email ?? 'No Address'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.contactNo.toString(),
              onChanged: (value) {
                // dataRow.schoolRegNumber = value;
              },
            )
                : Text(dataRow.contactNo.toString() ?? 'No school reg.no'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.gstNumber.toString(),
              onChanged: (value) {
                // dataRow.schoolType = value;
              },
            )
                : Text(dataRow.gstNumber.toString() ?? 'no type'),
          ),
          DataCell(
            isEditing
                ? TextFormField(
              initialValue: dataRow.cinNumber.toString(),
              onChanged: (value) {
                // dataRow.schoolType = value;
              },
            )
                : Text(dataRow.cinNumber.toString() ?? 'no type'),
          ),
          DataCell(
            isEditing ? SizedBox(
              width: 50,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: isFilePicked ? Colors.green : Colors.blue, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: Icon(Icons.image, color: isFilePicked ? Colors.green :Colors.blue),
                  onPressed: () => pickFile('profile'),
                ),
              ),
            ) :
            dataRow.panCard != null
                ? SizedBox(
              width: 50,
              child: CachedNetworkImage(
                imageUrl: ApiString.ImgBaseUrl + dataRow.panCard!,
                progressIndicatorBuilder:
                    (context, url, downloadProgress) =>
                    CircularProgressIndicator(
                        value: downloadProgress.progress),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            )
                : const SizedBox.shrink(),
          ),
          DataCell(
            ElevatedButton(
              onPressed: () =>
                  companyScreenState._toggleStatus(dataRow.id ?? ''),
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
                Get.to(
                        () => AssignedSchoolPage(companyID: dataRow.id.toString()));
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  backgroundColor: Colors.blue,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              child: const Text('View', style: TextStyle(color: Colors.white)),
            ),
          ),
          DataCell(
            ElevatedButton(
                onPressed: () {
                  companyScreenState._showSchoolBottomSheet(
                      Get.context!, dataRow.id);
                },
                child:
                const Text('Assign', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.green,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8))),
          ),
          DataCell(
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                companyScreenState.onDelete(
                  "You want to delete this company?",
                  dataRow.id!,
                );
              },
            ),
          ),
          DataCell(isEditing
              ? ElevatedButton(
            onPressed: () {
              // Save changes and exit edit mode
              companyScreenState.setState(() {
                companyScreenState.editingStates[dataRow.id!] = false;
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
              companyScreenState.setState(() {
                companyScreenState.editingStates[dataRow.id!] = true;
              });
              // Call update API here if needed
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Edit'),
          ))
        ],
      );
    }).toList();
  }

  Color _getButtonColor(String? approvalStatus) {
    switch (approvalStatus) {
      case "Approved":
        return Colors.green;
      case "Disapproved":
        return Colors.red;
      case "Pending":
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
  @override
  DataRow? getRow(int index) => dataTableRows[index];

  @override
  int get rowCount => dataTableRows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => companyScreenState.selectedCompanyIds.length;
}
