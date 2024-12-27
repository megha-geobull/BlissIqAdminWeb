
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
      body: Center(
        child: FractionallySizedBox(
          widthFactor: size.width > 800 ? 0.4 : 0.9,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: size.height * 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: size.height * 0.12,
                  ),

                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey.shade900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Login to your account',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 30),

                          // Email Field
                          _buildLabel('Email'),
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'Enter your email',
                            keyboardType: TextInputType.emailAddress,
                            validator: signupController.validateEmail,
                            prefixIcon: const Icon(Icons.email_outlined, color: Colors.blueAccent),
                          ),
                          const SizedBox(height: 20),

                          // Password Field
                          _buildLabel('Password'),
                          CustomTextField(
                            controller: _passwordController,
                            labelText: 'Enter your password',
                            obscureText: !_isPasswordVisible,
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.blueAccent),
                            sufixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              child: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Login Button
                          Obx(() {
                            return signupController.isLoading.value
                                ? const Center(child: CircularProgressIndicator())
                                : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    signupController.loginApi(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blueGrey.shade900,
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 20),

                          // Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.blueGrey.shade900,
        ),
      ),
    );
  }
}

