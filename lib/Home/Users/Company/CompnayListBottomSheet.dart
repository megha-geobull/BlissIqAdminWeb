import 'package:blissiqadmin/Home/Assign/AssignedSchoolPage.dart';
import 'package:blissiqadmin/auth/Controller/AuthController.dart';
import 'package:blissiqadmin/auth/Controller/CompanyController/CompanyController.dart';
import 'package:blissiqadmin/auth/Controller/SchoolController/SchoolController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompnayListBottomSheet extends StatefulWidget {
  final String? companyID;

  const CompnayListBottomSheet(this.companyID, {super.key});

  @override
  State<CompnayListBottomSheet> createState() => _CompnayListBottomSheetState();
}

class _CompnayListBottomSheetState extends State<CompnayListBottomSheet> {
  final CompanyController companyController = Get.put(CompanyController());
  final SchoolController schoolController = Get.put(SchoolController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      schoolController.getAllSchools();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.width * 0.38,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Select School',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => AssignedSchoolPage(companyID: widget.companyID.toString()));
                        print(widget.companyID);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.orange],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Assigned Schools',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: schoolController.allSchoolData.length,
                    itemBuilder: (context, index) {
                      var school = schoolController.allSchoolData[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 8.0,
                          ),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            school.schoolName ?? 'Unknown school',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ElevatedButton(
                              onPressed: () {
                                schoolController.assignSchoolApi(
                                    companyId: widget.companyID.toString(),
                                    schoolId: school.id.toString());
                                Navigator.pop(context, school.schoolName);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                              ),
                              child: const Text(
                                'Assign',
                                style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
