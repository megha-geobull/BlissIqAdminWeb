// import 'package:blissiqadmin/Global/Routes/AppRoutes.dart';
// import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
// import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:volunteerdashboard/global/AppColor.dart';
// import 'package:volunteerdashboard/global/CommonSizedBox.dart';
// import 'package:volunteerdashboard/global/CustomTextField.dart';
// import 'package:volunteerdashboard/global/routes/AppRoutes.dart';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:volunteerdashboard/src/auth/controller/AuthController.dart';
// import 'package:volunteerdashboard/src/profile/ProfileController/ProfileController.dart';
//
// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }
//
// class _SignUpScreenState extends State<SignUpScreen> {
//    AuthController signUpController = Get.find<AuthController>();
//   final  profileController = Get.find<ProfileController>();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(children: [
//           //   Container(
//           //     decoration: BoxDecoration(
//           // image: DecorationImage(image: AssetImage("assets/business-people-blue-background.jpg"),fit: BoxFit.cover)
//           //     ),
//           //   ),
//           SingleChildScrollView(
//             padding: EdgeInsets.symmetric(
//                 horizontal: MediaQuery.of(context).size.width * 0.05,
//                 vertical: MediaQuery.of(context).size.height * 0.02),
//             child: Form(
//               key: signUpController.formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Logo
//                   Center(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Center(
//                           child: GestureDetector(
//                             onTap: profileController.pickImage,
//                             child: Obx(
//                                   () => CircleAvatar(
//                                 radius: 50,
//                                 backgroundImage: profileController.imageFile.value != null
//                                     ? FileImage(profileController.imageFile.value!)
//                                     : AssetImage("assets/business.png") as ImageProvider,
//                                 child: const Align(
//                                   alignment: Alignment.bottomRight,
//                                   child: CircleAvatar(
//                                     backgroundColor: Colors.blue,
//                                     radius: 15,
//                                     child: Icon(Icons.add, size: 20, color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                             height: MediaQuery.of(context).size.height * 0.03),
//
//                         // Welcome Text
//                         Text(
//                           'Registration',
//                           style: TextStyle(
//                             fontSize: MediaQuery.of(context).size.width *
//                                 0.08, // Dynamic font size
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blueAccent,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   boxH30(),
//                   // User Type Dropdown
//                   DropdownButtonFormField<String>(
//                     value: signUpController.selectedUserType.value,
//                     decoration: InputDecoration(
//                       labelText: 'Select User Type',
//                       labelStyle: TextStyle(
//                         color: Colors.blueGrey,
//                         fontWeight: FontWeight.w500,
//                         fontSize: MediaQuery.of(context).size.width *
//                             0.05, // Smaller font size for better fit
//                       ),
//                       contentPadding: EdgeInsets.symmetric(
//                           horizontal: MediaQuery.of(context).size.width *
//                               0.04, // Dynamic padding
//                           vertical: MediaQuery.of(context).size.height * 0.015),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                         borderSide:
//                             BorderSide(color: Colors.blueAccent, width: 1),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                         borderSide: BorderSide(
//                             color: Colors.blueAccent.withOpacity(0.7),
//                             width: 0.8),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                         borderSide:
//                             BorderSide(color: Colors.blueAccent, width: 0.9),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                     onChanged: (value) {
//                       signUpController.selectedUserType.value = value!;
//                     },
//                     items: ['Mentor', 'Teacher'].map((String userType) {
//                       return DropdownMenuItem<String>(
//                         value: userType,
//                         child: Text(
//                           userType,
//                           style: TextStyle(
//                             fontSize: MediaQuery.of(context).size.width *
//                                 0.04, // Dynamic font size
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                     icon: Icon(
//                       Icons.arrow_drop_down_circle,
//                       color: Colors.blueAccent,
//                       size: MediaQuery.of(context).size.width *
//                           0.06, // Icon size adjustment
//                     ),
//                   ),
//                   boxH20(),
//                   // Name TextField
//                   CustomTextField(
//                     controller: signUpController.nameController,
//                     labelText: 'Full Name',
//                     keyboardType: TextInputType.text,
//                     prefixIcon: Icon(Icons.perm_identity),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please Enter your full name';
//                       }
//                       return null;
//                     },
//                   ),
//                   boxH20(),
//
//                   // Email TextField
//                   CustomTextField(
//                     controller: signUpController.emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     labelText: 'Email',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         return 'Please enter a valid email address';
//                       }
//                       return null;
//                     },
//                     prefixIcon: Icon(Icons.email_outlined),
//                   ),
//                   boxH20(),
//
//                   // Address TextField
//                   CustomTextField(
//                     controller: signUpController.addressController,
//                     labelText: 'Address',
//                     maxLines: 2,
//                     keyboardType: TextInputType.text,
//                     prefixIcon: Icon(Icons.location_on_outlined),
//                   ),
//                   boxH20(),
//
//                   // Phone Number & Country Code
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 3,
//                         child: Container(
//                           margin: EdgeInsets.only(right: 10),
//                           decoration: BoxDecoration(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(8.0)),
//                             border:
//                                 Border.all(width: 1, color: Colors.blueAccent),
//                           ),
//                           height: 50,
//                           alignment: Alignment.centerLeft,
//                           child: CountryCodePicker(
//                             onChanged: signUpController.onCountryChange,
//                             initialSelection: 'IN',
//                             favorite: ['+91', 'IN'],
//                             showCountryOnly: false,
//                             showOnlyCountryWhenClosed: false,
//                             alignLeft: false,
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         flex: 7,
//                         child: SizedBox(
//                           height: 50,
//                           child: TextFormField(
//                             inputFormatters: [
//                               LengthLimitingTextInputFormatter(10)
//                             ],
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please Enter your mobile number';
//                               }
//                               return null;
//                             },
//                             keyboardType: TextInputType.phone,
//                             controller: signUpController.phNoController,
//                             cursorColor: Colors.black,
//                             decoration: InputDecoration(
//                               border: OutlineInputBorder(),
//                               filled: true,
//                               fillColor: Colors.white.withOpacity(0.2),
//                               focusedBorder: const OutlineInputBorder(
//                                 borderSide: BorderSide(color: Colors.grey),
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10)),
//                               ),
//                               hintText: 'Enter mobile number',
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   boxH20(),
//
//                   // Experience TextField
//                   CustomTextField(
//                     controller: signUpController.experienceController,
//                     labelText: 'Experience (in years)',
//                     keyboardType: TextInputType.number,
//                     prefixIcon: Icon(
//                       Icons.work_outline,
//                     ),
//                   ),
//                   boxH20(),
//
//                   // Qualification TextField
//                   CustomTextField(
//                     controller: signUpController.qualificationController,
//                     labelText: 'Qualification',
//                     keyboardType: TextInputType.text,
//                     prefixIcon: Icon(Icons.school_outlined),
//                   ),
//                   boxH20(),
//
//                   // Bio/Introduction TextField
//                   CustomTextField(
//                     controller: signUpController.introBio,
//                     labelText: 'Introduction/Bio',
//                     maxLines: 4,
//                     prefixIcon: Icon(Icons.person_outline),
//                   ),
//                   boxH20(),
//
//                   // // Languages Proficient TextField
//                   // CustomTextField(
//                   //   controller: signUpController.languagesController,
//                   //   labelText: 'Languages Proficient in Teaching (optional)',
//                   //   keyboardType: TextInputType.text,
//                   //   prefixIcon: Icon(
//                   //     Icons.language_outlined,
//                   //   ),
//                   // ),
//                   // boxH20(),
//
//                   Obx(() {
//                     return CustomTextField(
//                       controller: signUpController.passwordController,
//                       labelText: 'Enter your password',
//                       keyboardType: TextInputType.visiblePassword,
//                       prefixIcon: Icon(
//                         Icons.password_outlined,
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please Enter your password';
//                         }
//                         return null;
//                       },
//                       obscureText: !signUpController.passwordVisible.value,
//                       sufixIcon: IconButton(
//                         icon: Icon(signUpController.passwordVisible.value
//                             ? Icons.visibility
//                             : Icons.visibility_off),
//                         onPressed: () {
//                           setState(
//                                 () {
//                               signUpController.passwordVisible.value = !signUpController.passwordVisible.value;
//                             },
//                           );
//                         },
//                       ),
//                     );
//                   },),
//                   boxH20(),
//                   CustomTextField(
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please Confirm your password';
//                       }
//                       else if(value != signUpController.passwordController.text)
//                         {
//                           return 'Passwords do not match';
//                         }
//                       return null;
//                     },
//
//                     controller: signUpController.confirmPasswordController,
//                     labelText: 'Confirm your password',
//                     keyboardType: TextInputType.visiblePassword,
//                     prefixIcon: Icon(
//                       Icons.password_rounded,
//                     ),
//                     obscureText: !signUpController.passwordVisible.value,
//                     sufixIcon: IconButton(
//                       icon: Icon(signUpController.passwordVisible.value
//                           ? Icons.visibility
//                           : Icons.visibility_off),
//                       onPressed: () {
//                         setState(
//                               () {
//                             signUpController.passwordVisible.value = !signUpController.passwordVisible.value;
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                   boxH20(),
//                   // Sign Up Button
//                   Obx(() {
//                     return Center(
//                       child: signUpController.isLoading.value ? CircularProgressIndicator()
//                           : ElevatedButton(
//                         onPressed: () {
//                           if(signUpController.formKey.currentState!.validate()) {
//                             print(signUpController.selectedUserType.value);
//                             print(signUpController.nameController.text);
//                             print(signUpController.emailController.text);
//                             print(signUpController.addressController.text);
//                             print(signUpController.phNoController.text);
//                             print(signUpController.experienceController.text);
//                             print(signUpController.qualificationController.text);
//                             print(signUpController.introBio.text);
//                             print(signUpController.passwordController.text);
//                             print(signUpController.confirmPasswordController.text);
//                             /// api calling
//                             signUpController.signupApi(
//                                 userType: signUpController.selectedUserType.value,
//                                 fullName: signUpController.nameController.text,
//                                 email: signUpController.emailController.text,
//                                 address: signUpController.addressController.text,
//                                 contactNo: signUpController.phNoController.text,
//                                 experience: signUpController.experienceController.text,
//                                 qualification: signUpController.qualificationController.text,
//                                 introBio: signUpController.introBio.text,
//                                 password: signUpController.passwordController.text,
//                                 confirmPassword: signUpController.confirmPasswordController.text,
//                                 context: context);
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blueAccent,
//                           minimumSize: Size(
//                               double.infinity,
//                               MediaQuery.of(context).size.height *
//                                   0.06), // Adjust height
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: Text(
//                           'Register',
//                           style: TextStyle(
//                               fontSize: MediaQuery.of(context).size.width *
//                                   0.05, // Font size adjustment
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     );
//                   },),
//                   boxH10(),
//
//                   // Login Prompt
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text('Already have an account?',
//                           style: TextStyle(fontSize: 16)),
//                       TextButton(
//                         onPressed: () {
//                           // Navigate back to Login Screen
//                           Get.toNamed(AppRoutes.login);
//                         },
//                         child: const Text(
//                           'Login',
//                           style:
//                               TextStyle(color: Colors.blueAccent, fontSize: 18),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }
