import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddMcqTypeWidget extends StatefulWidget {
  const AddMcqTypeWidget({super.key});

  @override
  State<AddMcqTypeWidget> createState() => _AddMcqTypeWidgetState();
}

class _AddMcqTypeWidgetState extends State<AddMcqTypeWidget> {



  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers =
      List.generate(4, (_) => TextEditingController());
  String? correctAnswer;
  TextEditingController correctAnswerController = TextEditingController();
  TextEditingController pointsController = TextEditingController();

  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 800;

          return Row(
            children: [
              if (isWideScreen)
                Container(
                  width: 250,
                  color: Colors.orange.shade100,
                  child: const MyDrawer(),
                ),
              Expanded(
                child: Scaffold(
                  appBar: isWideScreen
                      ? null
                      : AppBar(
                          title: const Text('Dashboard'),
                          backgroundColor: Colors.blue.shade100,
                        ),
                  drawer: isWideScreen ? null : Drawer(child: const MyDrawer()),
                  body: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 600,
                        ),
                        child: _buildMainContent(constraints),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMainContent(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const Text(
              'Enter Multiple Choice Question',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            SizedBox(
              width: 100,
              child: CustomTextField(
                controller: pointsController,
                maxLines: 1,
                labelText: "Points",
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        boxH30(),
        const Text(
          'Question :',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        boxH10(),
        CustomTextField(
          controller: questionController,
          maxLines: 1,
          labelText: "Enter your multiple choice question",
        ),
        boxH20(),
        const Text(
          'Upload Image (optional):',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.width * 0.08,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.orange, width: 0.5),
          ),
          child: const Center(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
                color: Colors.grey,
              ),
            ],
          )),
        ),
        boxH20(),
        const Text(
          'Options:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        boxH10(),
        // GridView for options
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Number of columns
            childAspectRatio: 4, // Aspect ratio of each item
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: optionControllers.length + 1, // Add one for the "+" button
          itemBuilder: (context, index) {
            if (index < optionControllers.length) {
              // Return the existing option text fields with a remove button
              return Stack(
                children: [
                  CustomTextField(
                    controller: optionControllers[index],
                    labelText: "Option ${index + 1}",
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          optionControllers.removeAt(index);
                        });
                      },
                    ),
                  ),
                ],
              );
            } else {
              // Return the "+" button to add a new option
              return GestureDetector(
                onTap: () {
                  setState(() {
                    optionControllers.add(TextEditingController());
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border.all(width: 0.6, color: Colors.orange),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }
          },
        ),

        boxH10(),
        const Text(
          'Correct Answer:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        CustomTextField(
          controller: correctAnswerController,
          labelText: "Enter your correct answer",
        ),
        boxH20(),
        CustomButton(
          label: "Add Question",
          onPressed: () {
            _submitQuestion();
          },
        ),
      ],
    );
  }

  void _submitQuestion() {
    // Validate inputs
    if (questionController.text.isEmpty) {
      _showError("Question cannot be empty");
      return;
    }

    if (optionControllers.any((controller) => controller.text.isEmpty)) {
      _showError("All options must be filled");
      return;
    }

    if (correctAnswerController.text.isEmpty) {
      _showError("Correct answer must be specified");
      return;
    }

    // Check if the correct answer is one of the options
    if (!optionControllers
        .any((controller) => controller.text == correctAnswerController.text)) {
      _showError("Correct answer must be one of the options");
      return;
    }

    // Print the question and options for demonstration
    print('Question: ${questionController.text}');
    print('Options:');
    for (var controller in optionControllers) {
      print(controller.text);
    }
    print('Correct Answer: ${correctAnswerController.text}');

    if (selectedImage != null) {
      print('Image Path: ${selectedImage!.path}');
    }

    // Clear the fields after submission
    questionController.clear();
    optionControllers.forEach((controller) => controller.clear());
    correctAnswerController.clear();
    setState(() {
      selectedImage = null;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
