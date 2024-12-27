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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'School Registration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      boxH20(),
                      CustomTextField(
                        controller: schoolController.nameController,
                        labelText: 'School Name',
                        keyboardType: TextInputType.text,
                        prefixIcon: Icon(Icons.school),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter your school name';
                          }
                          return null;
                        },
                      ),
                      boxH20(),
                      CustomTextField(
                        controller: schoolController.emailAddress,
                        keyboardType: TextInputType.emailAddress,
                        labelText: 'Email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      boxH20(),
                      CustomTextField(
                        controller: schoolController.schoolRegNumber,
                        keyboardType: TextInputType.text,
                        labelText: 'School reg.No',
                        prefixIcon: Icon(Icons.app_registration_sharp),
                      ),
                      boxH20(),
                      CustomTextField(
                        controller: schoolController.principalName,
                        labelText: 'Principal Name',
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      boxH20(),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                border: Border.all(width: 1, color: Colors.blueAccent),
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
                                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter your mobile number';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                controller: schoolController.phNoController,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.2),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
                        obscureText: !schoolController.passwordVisible.value,
                        sufixIcon: IconButton(
                          icon: Icon(schoolController.passwordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              schoolController.passwordVisible.value =
                              !schoolController.passwordVisible.value;
                            });
                          },
                        ),
                      ),
                      boxH20(),
                      CustomTextField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Confirm your password';
                          } else if (value != schoolController.passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        controller: schoolController.confirmPasswordController,
                        labelText: 'Confirm your password',
                        keyboardType: TextInputType.visiblePassword,
                        prefixIcon: const Icon(Icons.password_rounded),
                        obscureText: !schoolController.passwordVisible.value,
                        sufixIcon: IconButton(
                          icon: Icon(schoolController.passwordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              schoolController.passwordVisible.value =
                              !schoolController.passwordVisible.value;
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
                        );
                      }),
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