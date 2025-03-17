import 'package:blissiqadmin/Home/Controller/DashBoardEntrollmentController.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// class StudentsGraphController extends GetxController {
//   // Dropdown values
//   final selectedFilter = 'Monthly'.obs;
//   // Sample data for each filter
//   final weeklyData = [5, 10, 7, 12, 15, 9, 20]; // Data for 7 days
//   final monthlyData = [50, 40, 45, 60, 55, 65, 70, 75, 80, 85, 90, 100]; // Data for 12 months
//   final yearlyData = [500, 520, 550, 600, 700]; // Data for 5 years
//   // Data for the graph
//   final RxList<int> graphData = <int>[].obs;
//   @override
//   void onInit() {
//     super.onInit();
//     graphData.assignAll(monthlyData); // Default filter is Monthly
//   }
//   void updateGraphData(String filter) {
//     selectedFilter.value = filter;
//     if (filter == 'Weekly') {
//       graphData.assignAll(weeklyData);
//     } else if (filter == 'Monthly') {
//       graphData.assignAll(monthlyData);
//     } else if (filter == 'Yearly') {
//       graphData.assignAll(yearlyData);
//     }
//   }
// }

class StudentsGraphScreen extends StatefulWidget {
  @override
  _StudentsGraphScreenState createState() => _StudentsGraphScreenState();
}
class _StudentsGraphScreenState extends State<StudentsGraphScreen>{
  final DashBoardController controller = Get.put(DashBoardController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getAllEnrollments();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        height: Get.height * 0.56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "Student Enrollment",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Obx(
                        () => Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orangeAccent, width: 1),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: DropdownButton<String>(
                        value: controller.selectedFilter.value,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: 'Weekly',
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, color: Colors.orangeAccent),
                                SizedBox(width: 8),
                                Text('Weekly'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Monthly',
                            child: Row(
                              children: [
                                Icon(Icons.date_range, color: Colors.orangeAccent),
                                SizedBox(width: 8),
                                Text('Monthly'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Yearly',
                            child: Row(
                              children: [
                                Icon(Icons.calendar_view_day, color: Colors.orangeAccent),
                                SizedBox(width: 8),
                                Text('Yearly'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'Last 5 Years',
                            child: Row(
                              children: [
                                Icon(Icons.history, color: Colors.orangeAccent),
                                SizedBox(width: 8),
                                Text('Last 5 Years'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            controller.updateGraphData(value);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(
                    () => SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                              if (index >= 0 && index < controller.graphLabels.length) {
                                final label = controller.graphLabels[index];
                                // Shorten labels if needed
                                return Text(
                                  label.length > 5 ? label.substring(0, 3) : label,
                                  style: const TextStyle(fontSize: 12),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: controller.graphData.asMap().entries
                              .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
                              .toList(),
                          isCurved: true,
                          color: Colors.deepOrange,
                          barWidth: 1.5,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: true),
                        ),
                      ],
                      borderData: FlBorderData(
                        border: const Border(
                          bottom: BorderSide(color: Colors.black),
                          left: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}