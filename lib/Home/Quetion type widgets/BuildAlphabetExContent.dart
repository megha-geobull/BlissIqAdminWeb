import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Global/constants/CustomTextField.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class BuildAlphabetExContent extends StatefulWidget {
  final String? main_category_id;
  final String? sub_category_id;
  final String? topic_id;
  final String? sub_topic_id;
  final TextEditingController pointsController;

  const BuildAlphabetExContent({
    Key? key,
    required this.pointsController,
    required this.sub_topic_id,
    required this.topic_id,
    required this.sub_category_id,
    required this.main_category_id,
  }) : super(key: key);

  @override
  State<BuildAlphabetExContent> createState() => _BuildAlphabetExContentState();
}

class _BuildAlphabetExContentState extends State<BuildAlphabetExContent> {
  TextEditingController indexController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  List<Map<String, dynamic>> examples =
      []; // List to hold example images and names

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.orange,
      strokeWidth: 1,
      dashPattern: [4, 4],
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter index',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
                child: CustomTextField(
                  controller: indexController,
                  maxLines: 1,
                  labelText: "Enter index",
                ),
              ),
              boxH10(),
              const Text(
                'Enter title',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              boxH08(),
              CustomTextField(
                controller: titleController,
                maxLines: 1,
                labelText: "Enter title",
              ),
              boxH10(),

              // Displaying examples
              Row(
                children: [
                  const Text(
                    'Examples',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green),
                    onPressed: () => _addExample(),
                  ),
                ],
              ),
              boxH10(),
              ...examples.map((example) => _buildExampleRow(example)).toList(),
              boxH15(),
              CustomButton(
                label: "Add Question",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExampleRow(Map<String, dynamic> example) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: () => _pickImage(example),
            child: DottedBorder(
              color: Colors.grey,
              strokeWidth: 1,
              dashPattern: [4, 4],
              child: Container(
                width: 100,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: example['image'] != null
                    ? Image.memory(
                        example['image'],
                        fit: BoxFit.fill,
                      )
                    : const Center(
                        child: Text(
                        'Upload Image',
                        textAlign: TextAlign.center,
                      )),
              ),
            ),
          ),
        ),
        boxW20(),
        Expanded(
          flex: 3,
          child: CustomTextField(
            controller: example['nameController'],
            maxLines: 1,
            labelText: "Enter Example Name",
          ),
        ),
      ],
    );
  }

  void _addExample() {
    TextEditingController nameController = TextEditingController();
    examples.add({'image': null, 'nameController': nameController});
    setState(() {});
  }

  Future<void> _pickImage(Map<String, dynamic> example) async {
    var pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom, // Change to FileType.custom
      allowMultiple: false,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg'
      ], // Specify allowed image extensions
    );

    if (pickedFile != null && pickedFile.files.isNotEmpty) {
      setState(() {
        example['image'] = pickedFile.files.first.bytes;
      });
    }
  }
}
