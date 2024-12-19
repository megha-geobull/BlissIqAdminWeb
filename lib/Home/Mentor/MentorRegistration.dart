import 'package:blissiqadmin/Global/Routes/AppRoutes.dart';
import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/auth/Controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:get/get.dart';

class MentorRegistration extends StatefulWidget {
  @override
  _MentorRegistrationState createState() => _MentorRegistrationState();
}

class _MentorRegistrationState extends State<MentorRegistration> {
  final AuthController signUpController = Get.put(AuthController());

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
        child: Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width *
            0.4, // Adjusted width for better sizing
        child: Builder(builder: (context) {
          return Form(
            key: signUpController.formKey,
            child: SingleChildScrollView(
              // Added scroll view for better usability
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/icons/mentor.png',
                          height: constraints.maxHeight * 0.15,
                        ),
                        SizedBox(
                            height: constraints.maxHeight *
                                0.02), // Reduced height for spacing
                        const Text(
                          'Add New Mentor',
                          style: TextStyle(
                            fontSize:
                                22, // Increased font size for better visibility
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // Reduced height for spacing
                  buildDropdownField(
                    label: 'Select User Type',
                    value: signUpController.selectedUserType.value,
                    items: ['Mentor', 'Teacher'],
                    onChanged: (value) {
                      signUpController.selectedUserType.value = value!;
                    },
                  ),
                  const SizedBox(height: 15), // Reduced height for spacing
                  CustomTextField(
                    controller: signUpController.nameController,
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: const Icon(Icons.perm_identity),
                  ),
                  const SizedBox(height: 15), // Reduced height for spacing
                  CustomTextField(
                    controller: signUpController.emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: emailValidator,
                  ),
                  const SizedBox(height: 15), // Reduced height for spacing
                  CustomTextField(
                    controller: signUpController.addressController,
                    labelText: 'Address',
                    hintText: 'Enter your address',
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 15), // Reduced height for spacing
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
                            onChanged: signUpController.onCountryChange,
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
                            keyboardType: TextInputType.phone,
                            controller: signUpController.phNoController,
                            maxLines: 1,
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
                  boxH15(), // Reduced height for spacing
                  CustomTextField(
                    controller: signUpController.experienceController,
                    labelText: 'Experience (in years)',
                    hintText: 'Enter your experience',
                    prefixIcon: const Icon(Icons.work_outline),
                    keyboardType: TextInputType.number,
                  ),
                  boxH15(), // Reduced height for spacing
                  CustomTextField(
                    controller: signUpController.qualificationController,
                    labelText: 'Qualification',
                    hintText: 'Enter your qualification',
                    prefixIcon: const Icon(Icons.school_outlined),
                  ),
                  boxH15(), // Reduced height for spacing
                  CustomTextField(
                    controller: signUpController.introBio,
                    labelText: 'Introduction/Bio',
                    hintText: 'Tell us about yourself',
                    prefixIcon: const Icon(Icons.person_outline),
                    maxLines: 4,
                  ),
                  boxH15(), // Reduced height for spacing
                  CustomTextField(
                    controller: signUpController.languagesController,
                    labelText: 'Languages Proficient in Teaching (optional)',
                    hintText: 'Enter languages you can teach in',
                    prefixIcon: const Icon(Icons.language_outlined),
                  ),
                  boxH15(), // Reduced height for spacing
                  CustomTextField(
                    controller: signUpController.passwordController,
                    labelText: 'Enter your password',
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.password_outlined),
                    obscureText: true,
                  ),
                  boxH15(), // Reduced height for spacing
                  CustomTextField(
                    controller: signUpController.confirmPasswordController,
                    labelText: 'Confirm your password',
                    hintText: 'Re-enter your password',
                    prefixIcon: const Icon(Icons.password_rounded),
                    obscureText: true,
                  ),
                  boxH20(), // Spacing before the button
                  CustomButton(
                    label: 'Register',
                    onPressed: () => signUpController.handleSignUp(context),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    ));
  }

  Widget buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
        ),
      ),
      onChanged: onChanged,
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
    );
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
