import 'package:blissiqadmin/Global/Routes/AppRoutes.dart';
import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/auth/Controller/AuthController.dart';
import 'package:blissiqadmin/auth/Controller/SchoolController/SchoolController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';

class SchoolRegistration extends StatefulWidget {
  @override
  _SchoolRegistrationState createState() => _SchoolRegistrationState();
}

class _SchoolRegistrationState extends State<SchoolRegistration> {
  final SchoolController schoolController = Get.put(SchoolController());
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold (
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
                backgroundColor: Colors.grey.shade50,
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
                      onPressed: () {},
                    ),
                  ],
                ),
                drawer: isWideScreen ? null : Drawer(child: MyDrawer()),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                  child: _buildSchoolMainContent(constraints),
                ),
              ),
            ),
          ],
        );
      },
    ),
    );
  }

  Widget _buildSchoolMainContent(BoxConstraints constraints) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.38,
              child: Builder(builder: (context) {
                return Form(
                  key: schoolController.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset('assets/business.png', height: 100),
                      // const SizedBox(height: 30),
                      const Text(
                        'School Registration',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      boxH20(),

                      CustomTextField(
                        controller: schoolController.schoolNameController,
                        labelText: 'School Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the com.blissiq.school name';
                          }
                          return null;
                        },
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                      boxH20(),

                      CustomTextField(
                        controller: schoolController.schoolRegNumberController,
                        labelText: 'School Registration Number',
                        inputFormatters: [LengthLimitingTextInputFormatter(12)],
                        prefixIcon: Icon(Icons.assignment),
                      ),

                      boxH20(),

                      CustomTextField(
                        controller: schoolController.principalNameController,
                        labelText: 'Principal/Administrator Name',
                        prefixIcon: Icon(Icons.person_2_outlined),
                      ),
                      boxH20(),

                      CustomTextField(
                        controller: schoolController.principalEmailController,
                        labelText: 'Principal/Administrator Email',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icon(Icons.email_outlined),
                      ),

                      boxH20(),

                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                                border:
                                Border.all(width: 1, color: Colors.blueAccent),
                              ),
                              height: 50,
                              alignment: Alignment.centerLeft,
                              child: CountryCodePicker(
                                onChanged: schoolController.onCountryChange,
                                initialSelection: 'IN',
                                favorite: ['+91', 'IN'],
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: SizedBox(
                              height: 50,
                              child: TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter your mobile number';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                controller:
                                schoolController.principalPhoneController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                  ),
                                  hintText: 'Enter mobile number',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      boxH20(),

                      CustomTextField(
                        controller: schoolController.addressController,
                        labelText: 'School Address',
                        maxLines: 3,
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      boxH20(),
                      CustomTextField(
                        controller: schoolController.schoolTypeController,
                        labelText: 'School Type',
                        maxLines: 1,
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      // Obx(() => DropdownButtonFormField<String>(
                      //       value: schoolController.schoolType.value.isEmpty
                      //           ? null
                      //           : schoolController.schoolType.value,
                      //       items: schoolController.schoolTypes
                      //           .map((type) => DropdownMenuItem<String>(
                      //                 value: type,
                      //                 child: Text(type),
                      //               ))
                      //           .toList(),
                      //       onChanged: (value) {
                      //         schoolController.schoolType.value = value!;
                      //       },
                      //       decoration: const InputDecoration(
                      //         prefixIcon: Icon(Icons.school),
                      //         labelText: 'School Type',
                      //         border: OutlineInputBorder(),
                      //       ),
                      //     )),
                      boxH20(),
                      CustomTextField(
                        controller: schoolController.affiliatedCompanyController,
                        labelText: 'Affiliated Company',
                        maxLines: 1,
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      // Obx(() => DropdownButtonFormField<String>(
                      //       value: schoolController.affiliatedCompany.value.isEmpty
                      //           ? null
                      //           : schoolController.affiliatedCompany.value,
                      //       items: schoolController.affiliatedCompanies
                      //           .map((company) => DropdownMenuItem<String>(
                      //                 value: company,
                      //                 child: Text(company),
                      //               ))
                      //           .toList(),
                      //       onChanged: (value) {
                      //         schoolController.affiliatedCompany.value = value!;
                      //       },
                      //       decoration: const InputDecoration(
                      //         labelText: 'Affiliated Company',
                      //         prefixIcon: Icon(Icons.business),
                      //         border: OutlineInputBorder(),
                      //       ),
                      //     )),
                      boxH30(),

                      CustomTextField(
                        controller: schoolController.passwordController,
                        labelText: 'Enter your password',
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(Icons.password_outlined),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter your password';
                          }
                          return null;
                        },
                        obscureText: !schoolController.isPasswordVisible.value,
                        sufixIcon: IconButton(
                          icon: Icon(schoolController.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              schoolController.isPasswordVisible.value =
                              !schoolController.isPasswordVisible.value;
                            });
                          },
                        ),
                      ),
                      boxH20(),
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Confirm your password';
                          } else if (value != schoolController.confirmPasswordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        controller: schoolController.confirmPasswordController,
                        labelText: 'Confirm your password',
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(Icons.password_rounded),
                        obscureText: !schoolController.isConfirmPasswordVisible.value,
                        sufixIcon: IconButton(
                          icon: Icon(schoolController.isConfirmPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              schoolController.isConfirmPasswordVisible.value =
                              !schoolController.isConfirmPasswordVisible.value;
                            });
                          },
                        ),
                      ),
                      boxH20(),
                      Obx(() {
                        return Center(
                          child: schoolController.isLoading.value
                              ? CircularProgressIndicator()
                              : CustomButton(
                            label: "School Register",
                            onPressed: () {
                              if (schoolController.formKey.currentState!.validate()) {
                                schoolController.schoolRegistration(
                                    schoolName: schoolController.nameController.text,
                                    schoolRegNumber: schoolController.schoolRegNumber.text,
                                    principalName: schoolController.principalName.text,
                                    principalEmail: schoolController.emailAddress.text,
                                    principalPhone: schoolController.phNoController.text,
                                    address: schoolController.addressController.text,
                                    schoolType: "schoolType",
                                    password: schoolController.passwordController.text,
                                    confirm_password: schoolController.confirmPasswordController.text,
                                    context: context);
                                // schoolController.schoolRegNumber(
                                //   fullName: schoolController.nameController.text,
                                //   email: schoolController.emailAddress.text,
                                //   address: schoolController.addressController.text,
                                //   contactNo: schoolController.phNoController.text,
                                //   password: schoolController.passwordController.text,
                                //   confirmPassword: schoolController.confirmPasswordController.text,
                                //   context: context,
                                // );
                              }
                            },
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}