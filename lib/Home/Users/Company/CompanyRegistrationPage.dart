import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/auth/Controller/AuthController.dart';
import 'package:blissiqadmin/auth/Controller/CompanyController/CompanyController.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CompanyRegistrationPage extends StatefulWidget {
  const CompanyRegistrationPage({super.key});

  @override
  State<CompanyRegistrationPage> createState() =>
      _CompanyRegistrationPageState();
}

class _CompanyRegistrationPageState extends State<CompanyRegistrationPage> {
  final CompanyController companyController = Get.put(CompanyController());

  List<PlatformFile>? _paths;
  var pathsFile;
  var pathsFileName;

  // File picker for profile image
  pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      onFileLoading: (FilePickerStatus status) => print("status .... $status"),
      allowedExtensions: [
        'bmp', 'dib', 'gif', 'jfif', 'jpe', 'jpg', 'jpeg', 'pbm', 'pgm',
        'ppm', 'pnm', 'pfm', 'png', 'apng', 'blp', 'bufr', 'cur', 'pcx',
        'dcx', 'dds', 'ps', 'eps', 'fit', 'fits', 'fli', 'flc', 'ftc',
        'ftu', 'gbr', 'grib', 'h5', 'hdf', 'jp2', 'j2k', 'jpc', 'jpf',
        'jpx', 'j2c', 'icns', 'ico', 'im', 'iim', 'mpg', 'mpeg', 'tif',
        'tiff', 'mpo', 'msp', 'palm', 'pcd', 'pdf', 'pxr', 'psd', 'qoi',
        'bw', 'rgb', 'rgba', 'sgi', 'ras', 'tga', 'icb', 'vda', 'vst',
        'webp', 'wmf', 'emf', 'xbm', 'xpm'
      ],
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
                    child: _buildCompanyMainContent(constraints),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCompanyMainContent(BoxConstraints constraints) {
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
                key: companyController.formKey,
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
                            'Company Registration',
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
                            child: pathsFile != null
                                ? CircleAvatar(
                              radius: 50,
                              backgroundImage: MemoryImage(pathsFile!),
                              child: const Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  radius: 15,
                                  child: Icon(Icons.add, size: 18, color: Colors.black),
                                ),
                              ),
                            )
                                : Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[200],
                              ),
                              child: const Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  radius: 15,
                                  child: Icon(Icons.add, size: 18, color: Colors.black),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    boxH30(),
                    // Name TextField
                    CustomTextField(
                      controller: companyController.companyNameController,
                      labelText: 'Company Name',
                      keyboardType: TextInputType.text,
                      prefixIcon: Icon(Icons.perm_identity),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your Company name';
                        }
                        return null;
                      },
                    ),
                    boxH20(),
                    CustomTextField(
                      controller: companyController.ownerNameController,
                      labelText: 'Company Owner Name',
                      keyboardType: TextInputType.text,
                      prefixIcon: Icon(Icons.perm_identity),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter Owner name';
                        }
                        return null;
                      },
                    ),
                    boxH20(),
                    // Email TextField
                    CustomTextField(
                      controller: companyController.emailController,
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
                              border: Border.all(
                                  width: 1, color: Colors.blueAccent),
                            ),
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: CountryCodePicker(
                              onChanged: companyController.onCountryChange,
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
                              controller: companyController.contactNumberController,
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
                      controller: companyController.panCardController,
                      labelText: 'PanCard No (optional)',
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.work_outline),
                    ),
                    boxH20(),

                    // Qualification TextField
                    CustomTextField(
                      controller: companyController.gstNumberController,
                      labelText: 'Gst Number',
                      keyboardType: TextInputType.text,
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                    boxH20(),

                    // Bio/Introduction TextField
                    CustomTextField(
                      controller: companyController.cinNumberController,
                      labelText: 'Cin Numer',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    boxH20(),
                    CustomTextField(
                      controller: companyController.passwordController,
                      labelText: 'Enter your password',
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(Icons.password_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your password';
                        }
                        return null;
                      },
                      obscureText: !companyController.passwordVisible.value,
                      sufixIcon: IconButton(
                        icon: Icon(companyController.passwordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            companyController.passwordVisible.value =
                                !companyController.passwordVisible.value;
                          });
                        },
                      ),
                    ),
                    boxH20(),
                    Obx(() {
                      return Center(
                        child: companyController.isLoading.value
                            ? CircularProgressIndicator()
                            : CustomButton(
                                label: "Register",
                                onPressed: () {
                                  if (companyController.formKey.currentState!.validate()) {
                                    companyController.companyRegistration(
                                      companyName: companyController.companyNameController.text,
                                      ownerName:  companyController.ownerNameController.text,
                                      email: companyController.emailController.text,
                                      contactNo: companyController.contactNumberController.text,
                                      password: companyController.passwordController.text,
                                      context: context,
                                      profileImageBytes: pathsFile,
                                      profileImageName: pathsFileName,
                                      panCardNo: companyController.panCardController.text,
                                      cinNumber: companyController.cinNumberController.text,
                                      gstNumber: companyController.gstNumberController.text,
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
