import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Global/constants/CommonSizedBox.dart';
import 'package:blissiqadmin/Home/Attendance/AttendanceHistoryScreen.dart';
import 'package:blissiqadmin/Home/Conversational/ConversationalScreen.dart';
import 'package:blissiqadmin/Home/Drawer/MainCategoriesPage.dart';
import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Grammer/GrammarScreen.dart';
import 'package:blissiqadmin/Home/StudentsGraphScreen.dart';
import 'package:blissiqadmin/Home/Toddler/ToddlerEnglishScreen.dart';
import 'package:blissiqadmin/Home/UserPieChart.dart';
import 'package:blissiqadmin/Home/Vocabulary/VocabularyScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}




class _HomePageState extends State<HomePage> {
  String profileImage = "assets/icons/icon_white.png";

  final List<Map<String, dynamic>> mainCategoryItems = [
    {
      "title": "Vocabulary",
      "imagePath": "assets/images/vocabulary.png",
      "gradient": LinearGradient(
        colors: [Colors.blue.shade200, Colors.blue.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      "title": "Toddler English",
      "imagePath": "assets/images/toddler-abc.png",
      "gradient": LinearGradient(
        colors: [Colors.green.shade200, Colors.green.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      "title": "Conversational",
      "imagePath": "assets/images/conversational.png",
      "gradient": LinearGradient(
        colors: [Colors.orange.shade200, Colors.orange.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      "title": "Grammar",
      "imagePath": "assets/Images/grammer.png",
      "gradient": LinearGradient(
        colors: [Colors.purple.shade200, Colors.purple.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
  ];

  final List<Map<String, dynamic>> students = [
    {
      'rank': '1',
      'image': 'assets/top_profile.png',
      'name': 'Sumit Kadam',
      'tasksCompleted': 45,
      'points': 1200,
    },
    {
      'rank': '2',
      'image': 'assets/girl.png',
      'name': 'Sakshi Patil',
      'tasksCompleted': 40,
      'points': 1150,
    },
    {
      'rank': '3',
      'image': 'assets/girl_profile.png',
      'name': 'Rinku Sharma',
      'tasksCompleted': 35,
      'points': 1100,
    },
    {
      'rank': '4',
      'image': 'assets/bussiness-man.png',
      'name': 'Vikas Shinde',
      'tasksCompleted': 30,
      'points': 1050,
    },
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check screen size for responsiveness
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
                  backgroundColor: Colors.grey.shade100,
                  appBar: isWideScreen
                      ? null // Remove AppBar if the drawer is always visible
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
                              onPressed: () {
                                // Handle notifications
                              },
                            ),
                          ],
                        ),
                  drawer:
                      isWideScreen ? null : const Drawer(child: MyDrawer()),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: _buildMainContent(constraints),
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
    int crossAxisCount = constraints.maxWidth > 900
        ? 2
        : constraints.maxWidth > 600
            ? 3
            : 2;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: constraints.maxHeight * 0.48,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recent Accounts Section
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.white,
                      elevation: 0.9,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Accounts",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            boxH10(),
                            const UserPieChart()
                          ],
                        ),
                      ),
                    ),
                  ),

                  boxW20(),

                  Expanded(
                    flex: 1,
                    child: Card(
                      color: Colors.white,
                      elevation: 0.9,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Categories",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            boxH10(),
                            SizedBox(
                              height: constraints.maxHeight * 0.36,
                              child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: mainCategoryItems.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 2.6,
                                ),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // Handle navigation
                                      switch (index) {
                                        case 0:
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VocabularyScreen()),
                                          );
                                          break;
                                        case 1:
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MainCategoriesPage()),
                                          );
                                          break;
                                        case 2:
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ConversationalScreen()),
                                          );
                                          break;
                                        case 3:
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const GrammarScreen()),
                                          );
                                          break;
                                      }
                                    },
                                    child: Card(
                                      elevation: 0.8,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: mainCategoryItems[index]
                                              ["gradient"],
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                mainCategoryItems[index]
                                                    ["imagePath"],
                                                fit: BoxFit.cover,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.060,
                                              ),
                                              Text(
                                                mainCategoryItems[index]["title"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: constraints.maxWidth >
                                                          1200
                                                      ? 18
                                                      : constraints.maxWidth > 800
                                                          ? 17
                                                          : constraints.maxWidth >
                                                                  600
                                                              ? 16
                                                              : 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black.withOpacity(0.7),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            boxH10(),
            Row(
              children: [
                Expanded(child: _leaderBoard()),
                Expanded(child: StudentsGraphScreen()),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _leaderBoard() {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: Get.height * 0.5,
          width: Get.width * 0.4, // Wider to fit better in the UI
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                "Leaderboard",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Header
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                      child: Text('Ranking', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Center(child: Text('Profile', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold))),
                    ),
                    Expanded(
                      child: Text('Name', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Text('Tasks', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: Text('Points', style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Body
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: index.isEven ? Colors.grey.shade100 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                student['rank'].toString(),
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(student['image']),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                student['name'],
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  student['tasksCompleted'].toString(),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  student['points'].toString(),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

