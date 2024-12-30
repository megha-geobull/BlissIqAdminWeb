import 'package:blissiqadmin/Home/Users/Company/CompanyScreen.dart';
import 'package:blissiqadmin/Home/Users/Mentor/MentorScreen.dart';
import 'package:blissiqadmin/Home/Users/School/SchoolScreen.dart';
import 'package:blissiqadmin/Home/Users/Students/StudentScreen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserPieChart extends StatefulWidget {
  const UserPieChart({Key? key}) : super(key: key);

  @override
  State<UserPieChart> createState() => _UserPieChartState();
}

class _UserPieChartState extends State<UserPieChart> {
  int touchedIndex = -1;

  final List<Map<String, dynamic>> userList = [
    {
      "title": "Mentors",
      "imagePath": "assets/icons/mentor.png",
      "gradient": LinearGradient(
        colors: [Colors.red.shade200, Colors.redAccent.shade200],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      "value": 25,
    },
    {
      "title": "Companies",
      "imagePath": "assets/icons/Company.png",
      "gradient": LinearGradient(
        colors: [Colors.blueAccent.shade100, Colors.blue.shade200],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      "value": 30,
    },
    {
      "title": "Schools",
      "imagePath": "assets/icons/School.png",
      "gradient": LinearGradient(
        colors: [Colors.deepOrange.shade200, Colors.deepOrange.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      "value": 20,
    },
    {
      "title": "Students",
      "imagePath": "assets/icons/students.png",
      "gradient": LinearGradient(
        colors: [Colors.pinkAccent.shade100, Colors.pinkAccent.shade200],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      "value": 25,
    },
  ];

  void navigateToScreen(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MentorScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompanyScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  SchoolScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: AspectRatio(
            aspectRatio: 1.7,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      setState(() {
                        touchedIndex = -1;
                      });
                      return;
                    }

                    setState(() {
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });

                    if (event is FlTapUpEvent && touchedIndex != -1) {
                      navigateToScreen(touchedIndex);
                    }
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 4,
                centerSpaceRadius: 30,
                sections: showingSections(),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(userList.length, (i) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: userList[i]["gradient"] as LinearGradient,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      userList[i]["title"] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(userList.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 120.0 : 100.0;
      final widgetSize = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        value: userList[i]["value"] as double,
        title: '${userList[i]["value"]}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: (userList[i]["gradient"] as LinearGradient).colors[1],
        // badgeWidget: _Badge(
        //   userList[i]["imagePath"] as String,
        //   size: widgetSize,
        // ),
        // badgePositionPercentageOffset: .98,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
      this.imagePath, {
        required this.size,
      });
  final String imagePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.15),
      child: Center(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}