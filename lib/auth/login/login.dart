
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Global/Widgets/Button/CustomButton.dart';
import '../../Global/constants/CommonSizedBox.dart';
import '../../Global/constants/CustomTextField.dart';
import '../Controller/AuthController.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final AuthController signupController = Get.put(AuthController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding:EdgeInsets.symmetric(horizontal: 300),
            child: Center(
              child: Stack(
                children: [
                  // Fixed background image
              
                  Positioned(
                    top: size.height * 0.2,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: size.height * 0.09, // Responsive size
                      ),
                    ),
                  ),
              
                  // Scrollable form content
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(top: size.height * 0.38),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Hello!',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey.shade800,
                                ),
                              ),
                              boxH05(),
                              const Text(
                                'Enter the correct Email & password to login into the account ',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              boxH15(),
              
                              // Email Field
                              _buildLabel('Email'),
                              CustomTextField(
                                controller: _emailController,
                                labelText: 'Enter your email',
                                keyboardType: TextInputType.emailAddress,
                                validator: signupController.validateEmail,
                                prefixIcon: Icon(Icons.email_outlined, color: Colors.blueAccent, size: size.width * 0.02),
                              ),
                              boxH15(),
              
                              // Password Field
                              _buildLabel('Password'),
                              CustomTextField(
                                controller: _passwordController,
                                labelText: 'Enter your password',
                                obscureText: !_isPasswordVisible,
                                prefixIcon: Icon(Icons.lock_outline, color: Colors.blueAccent, size: size.width * 0.02),
                                sufixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  child: Icon(
                                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.blueAccent,
                                    size: size.width * 0.02,
                                  ),
                                ),
                              ),
                              boxH20(),
              
                              Obx(() {
                                return Center(
                                  child: signupController.isLoading.value
                                      ? CircularProgressIndicator()
                                      : CustomButton(
                                    label: 'Login',
                                    color: Colors.amber,
                                    textColor: Colors.blueGrey.shade800,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        signupController.loginApi(
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text.trim(),
                                        );
                                      }
                                    },
                                  ),
                                );
                              }),
                              boxH05(),
              
                              // Forgot Password Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //       const ForgotPasswordScreen()),
                                      // );
                                    },
                                    child: Text(
                                      'Forgot Password',
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              boxH10(),
              
                              // Sign Up Link
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey.shade800,
          fontSize: 14,
        ),
      ),
    );
  }
}

