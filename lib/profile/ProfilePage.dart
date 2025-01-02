import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/profile/ProfileController.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileController profileController = Get.put(ProfileController());

  List<PlatformFile>? _paths;
  var pathsFile;
  var pathsFileName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadProfile();
  }

  _loadProfile() async {
    await profileController.getProfile();
    setState(() {
      profileController.nameController.text = profileController.profile['user_name'] ?? '';
      profileController.emailController.text = profileController.profile['email'] ?? '';
      profileController.phNoController.text = profileController.profile['contact_no'].toString() ?? '';
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
                    key: profileController.formKey,
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
                                'Profile',
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

                        boxH20(),
                        // Name TextField
                        CustomTextField(
                          controller: profileController.nameController,
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
                          controller: profileController.emailController,
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
                                  border:
                                  Border.all(width: 1, color: Colors.blueAccent),
                                ),
                                height: 50,
                                alignment: Alignment.centerLeft,
                                child: CountryCodePicker(
                                  onChanged: profileController.onCountryChange,
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
                                  controller: profileController.phNoController,
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

                        // Sign Up Button
                        Obx(() {
                          return Center(
                            child: profileController.isLoading.value
                                ? const CircularProgressIndicator()
                                : CustomButton(
                              label: "Save Changes",
                              onPressed: () {
                                if (profileController.formKey.currentState!
                                    .validate()) {
                                  profileController.editProfile(
                                    user_name: profileController.nameController.text,
                                    email: profileController.emailController.text,
                                    contact_no: profileController.phNoController.text,
                                    context: context, profile_image: pathsFile,
                                  );
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