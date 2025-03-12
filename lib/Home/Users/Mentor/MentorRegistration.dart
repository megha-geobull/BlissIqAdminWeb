import 'package:blissiqadmin/Global/Routes/AppRoutes.dart';
import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/SchoolSearchScreen.dart';
import 'package:blissiqadmin/auth/Controller/AuthController.dart';
import 'package:blissiqadmin/auth/Controller/SchoolController/SchoolController.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:get/get.dart';

class MentorRegistration extends StatefulWidget {
  @override
  _MentorRegistrationState createState() => _MentorRegistrationState();
}

class _MentorRegistrationState extends State<MentorRegistration> {
  final AuthController mentorController = Get.put(AuthController());
  String? selectedSchool;
  List<PlatformFile>? _paths;
  var pathsFile;
  var pathsFileName;
  final SchoolController schoolController = Get.put(SchoolController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      schoolController.getAllSchools();
    });
  }

  // File picker for profile image
  pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      onFileLoading: (FilePickerStatus status) => print("status .... $status"),
      allowedExtensions: ['png', 'jpg', 'jpeg', 'heic'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _paths = result.files;
        pathsFile = _paths!.first.bytes; // Store the bytes
        pathsFileName = _paths!.first.name; // Store the file name
      });
    } else {
      print('No file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                key: mentorController.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Logo
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Welcome Text
                          const Text(
                            'Mentor Registration',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          boxH10(),

                          GestureDetector(
                              onTap: () {
                                pickFile();
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: pathsFile != null
                                    ? MemoryImage(pathsFile!)
                                    : AssetImage("assets/icons/mentor.png")
                                        as ImageProvider,
                                child: const Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.orange,
                                    radius: 15,
                                    child: Icon(Icons.add,
                                        size: 18, color: Colors.white),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    boxH30(),
                    // User Type Dropdown
                    DropdownButtonFormField<String>(
                      value: mentorController.selectedUserType.value,
                      decoration: InputDecoration(
                        labelText: 'Select User Type',
                        labelStyle: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.01,
                          vertical: MediaQuery.of(context).size.height * 0.01,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: Colors.blueAccent.withOpacity(0.7),
                              width: 0.8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 0.9),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        mentorController.selectedUserType.value = value!;
                      },
                      items: ['Mentor', 'Teacher'].map((String userType) {
                        return DropdownMenuItem<String>(
                          value: userType,
                          child: Text(
                            userType,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                        );
                      }).toList(),
                      icon: Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.grey.shade600,
                        size: 18,
                      ),
                    ),
                    boxH20(),
                    Obx(() {
                      if (schoolController.isLoading.value) {
                        return const CircularProgressIndicator();
                      } else {
                        return DropdownButtonFormField<String>(
                          value: selectedSchool,
                          decoration: InputDecoration(
                            labelText: 'Select School',
                            labelStyle: const TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.01,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(
                                  color: Colors.blueAccent, width: 0.8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedSchool = value;
                            });
                          },
                          items: schoolController.allSchoolData.map((school) {
                            return DropdownMenuItem<String>(
                              value: school.id,
                              child: Text(
                                school.schoolName.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            );
                          }).toList(),
                          icon: Icon(
                            Icons.arrow_drop_down_circle,
                            color: Colors.grey.shade600,
                            size: 18,
                          ),
                        );
                      }
                    }),
                    boxH20(),
                    boxH05(),
                    const Center(child: Text("OR")),
                    boxH05(),
                    Obx(() => Container(
                          width: Get.width * 0.9,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'School: ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            mentorController.selectedSchoolName
                                                .value, // ✅ Will update instantly
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.blue,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SchoolSearchScreen()),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.add,
                                          color: Colors.white, size: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                    boxH02(),
                    const Text(
                      '*If your school is not found in the dropdown, search and add it here.',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    boxH20(),
                    // Name TextField
                    CustomTextField(
                      controller: mentorController.nameController,
                      labelText: 'Full Name',
                      keyboardType: TextInputType.text,
                      prefixIcon: Icon(Icons.perm_identity),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your full name';
                        }
                        return null;
                      },
                    ),
                    boxH20(),

                    // Email TextField
                    CustomTextField(
                      controller: mentorController.emailController,
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

                    // Address TextField
                    CustomTextField(
                      controller: mentorController.addressController,
                      labelText: 'Address',
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    boxH20(),

                    // Phone Number & Country Code
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              border: Border.all(
                                  width: 1, color: Colors.blueAccent),
                            ),
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: CountryCodePicker(
                              onChanged: mentorController.onCountryChange,
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
                              controller: mentorController.phNoController,
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

                    // Experience TextField
                    CustomTextField(
                      controller: mentorController.experienceController,
                      labelText: 'Experience (in years)',
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.work_outline),
                    ),
                    boxH20(),

                    // Qualification TextField
                    CustomTextField(
                      controller: mentorController.qualificationController,
                      labelText: 'Qualification',
                      keyboardType: TextInputType.text,
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                    boxH20(),

                    // Bio/Introduction TextField
                    CustomTextField(
                      controller: mentorController.introBio,
                      labelText: 'Introduction/Bio',
                      maxLines: 3,
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    boxH20(),
                    CustomTextField(
                      controller: mentorController.passwordController,
                      labelText: 'Enter your password',
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(Icons.password_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your password';
                        }
                        return null;
                      },
                      obscureText: !mentorController.passwordVisible.value,
                      sufixIcon: IconButton(
                        icon: Icon(mentorController.passwordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            mentorController.passwordVisible.value =
                                !mentorController.passwordVisible.value;
                          });
                        },
                      ),
                    ),
                    boxH20(),
                    CustomTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Confirm your password';
                        } else if (value !=
                            mentorController.passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      controller: mentorController.confirmPasswordController,
                      labelText: 'Confirm your password',
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(Icons.password_rounded),
                      obscureText: !mentorController.passwordVisible.value,
                      sufixIcon: IconButton(
                        icon: Icon(mentorController.passwordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            mentorController.passwordVisible.value =
                                !mentorController.passwordVisible.value;
                          });
                        },
                      ),
                    ),
                    boxH20(),
                    // Sign Up Button
                    Obx(() {
                      return Center(
                        child: mentorController.isLoading.value
                            ? CircularProgressIndicator()
                            : CustomButton(
                                label: "Register",
                                onPressed: () async {
                                  if (mentorController
                                      .selectedSchoolAddress.isNotEmpty) {
                                    await mentorController.registerNewSchool(
                                        name: mentorController
                                            .selectedSchoolName.value,
                                        address: mentorController
                                            .selectedSchoolAddress.value,
                                        latitude: mentorController
                                            .selectedSchoolLat.value,
                                        longitude: mentorController
                                            .selectedSchoolLng.value);
                                    print(
                                        "School ID: ${mentorController.selectedSchoolId}");
                                  }

                                  if (mentorController
                                      .selectedSchoolId.isNotEmpty) {
                                    if (mentorController.formKey.currentState!
                                        .validate()) {
                                      mentorController
                                          .mentorRegistration(
                                        userType: mentorController
                                            .selectedUserType.value,
                                        fullName: mentorController
                                            .nameController.text,
                                        email: mentorController
                                            .emailController.text,
                                        address: mentorController
                                            .addressController.text,
                                        contactNo: mentorController
                                            .phNoController.text,
                                        experience: mentorController
                                            .experienceController.text,
                                        qualification: mentorController
                                            .qualificationController.text,
                                        introBio:
                                            mentorController.introBio.text,
                                        password: mentorController
                                            .passwordController.text,
                                        confirmPassword: mentorController
                                            .confirmPasswordController.text,
                                        profileImageBytes: pathsFile,
                                        schoolId: mentorController
                                            .selectedSchoolId.value,
                                        schoolName: mentorController
                                            .selectedSchoolName.value,
                                        context: context,
                                      )
                                          .then((response) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Registration successful!')),
                                        );
                                        Navigator.pop(context, true);
                                      }).catchError((error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Error occurred: $error')),
                                        );
                                      });
                                    }
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
    ));
  }
}
