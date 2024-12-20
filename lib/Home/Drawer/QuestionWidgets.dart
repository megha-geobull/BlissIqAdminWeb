import 'package:blissiqadmin/Global/Widgets/Button/CustomButton.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Quetion%20type%20widgets/AddMcqTypeWidget/AddMcqTypeWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionWidgets extends StatefulWidget {
  const QuestionWidgets({super.key});

  @override
  State<QuestionWidgets> createState() => _QuestionWidgetsState();
}

class _QuestionWidgetsState extends State<QuestionWidgets> {
  final List<Map<String, dynamic>> questionTypes = [
    {
      'title': 'Multiple Choice Question',
      'widget': AddMcqTypeWidget(),
    },
    {
      'title': 'Complete the Word',
      'widget': CompleteTheWord(),
    },
    {
      'title': 'Multiple Choice Question',
      'widget': AddMcqTypeWidget(),
    },
    {
      'title': 'Complete the Word',
      'widget': CompleteTheWord(),
    },
    {
      'title': 'Multiple Choice Question',
      'widget': AddMcqTypeWidget(),
    },
    {
      'title': 'Complete the Word',
      'widget': CompleteTheWord(),
    },
  ];

  int selectedQuestionTypeIndex = 0;

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
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 800,
                      ),
                      child: _buildMainContent(),
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

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'All Question Widgets',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                childAspectRatio: 4, // Aspect ratio of each item
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: questionTypes.length,
              itemBuilder: (context, index) {
                return CustomButton(
                  color: Colors.orange.shade200,
                  textColor: Colors.black,
                  borderRadius: 10,
                  onPressed: () {
                    setState(() {
                      selectedQuestionTypeIndex = index;
                    });
                    Get.to(() => questionTypes[index]['widget'] as Widget);
                  },
                  label: questionTypes[index]['title'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}

// Example CompleteTheWord widget
class CompleteTheWord extends StatelessWidget {
  const CompleteTheWord({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Complete the Word:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Add your fill-in-the-blank logic here
        TextField(
          decoration: InputDecoration(
            labelText: 'Enter the word',
            border: OutlineInputBorder(),
          ),
        ),
        // Add more fields or logic as needed
      ],
    );
  }
}