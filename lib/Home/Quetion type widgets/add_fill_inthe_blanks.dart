import 'dart:io';

import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddFillInTheBlanks extends StatefulWidget {
  const AddFillInTheBlanks({super.key});

  @override
  State<AddFillInTheBlanks> createState() => _AddFillInTheBlanksState();
}

class _AddFillInTheBlanksState extends State<AddFillInTheBlanks> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();
  final TextEditingController answerController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final List<TextEditingController> optionControllers = [];


  // Function to add an option field
  void addOptionField() {
    setState(() {
      optionControllers.add(TextEditingController());
    });
  }

  // Function to remove an option field
  void removeOptionField(int index) {
    setState(() {
      optionControllers[index].dispose();
      optionControllers.removeAt(index);
    });
  }

  String? imagePath;
  final ImagePicker _picker = ImagePicker();
  // Function to pick an image from the gallery
  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    pointsController.dispose();
    answerController.dispose();
    titleController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Points Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Question title:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: titleController,
                        labelText: 'Enter question title here...',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Points:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: pointsController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: '00',
                              prefixIcon: SizedBox(
                                width: 40,
                                height: 40,
                                child: Image.asset("assets/coins.png"),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text(
              'Question:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: questionController,
              labelText: 'Enter your question here...',
              maxLines: 3,
            ),

            const SizedBox(height: 16),
            const Text(
              'Question Image (Optional):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: imagePath == null ? 80 : 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: imagePath == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.image, size: 40),
                    Text('Tap to add image'),
                  ],
                )
                    : kIsWeb
                    ? Image.network(
                  imagePath!,
                  fit: BoxFit.cover,
                )
                    : Image.file(
                  File(imagePath!),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Current Answer:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: answerController,
              labelText: 'Enter current answer...',
            ),

            const SizedBox(height: 16),
            const Text(
              'Options:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // GridView to display options
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns in the grid
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: optionControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: optionControllers[index],
                          labelText: 'Option ${index + 1}',
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeOptionField(index),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 8),

            // Button to add a new option
            TextButton.icon(
              onPressed: addOptionField,
              icon: const Icon(Icons.add, size: 18, color: Colors.white),
              label: const Text(
                'Add Option',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                overlayColor: MaterialStateProperty.all<Color>(Colors.orangeAccent.withOpacity(0.2)),
              ),
            ),

            const SizedBox(height: 30),

            // Save button
            Center(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    // Save logic
                  },
                  child: const Text(
                    'Add Question',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 2, // Add slight elevation for a shadow effect
                    shadowColor: Colors.orangeAccent, // Optional: shadow color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
