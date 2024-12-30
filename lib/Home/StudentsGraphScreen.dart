import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class StudentsGraphController extends GetxController {
  // Dropdown values
  final selectedFilter = 'Monthly'.obs;
  // Sample data for each filter
  final weeklyData = [5, 10, 7, 12, 15, 9, 20]; // Data for 7 days
  final monthlyData = [50, 40, 45, 60, 55, 65, 70, 75, 80, 85, 90, 100]; // Data for 12 months
  final yearlyData = [500, 520, 550, 600, 700]; // Data for 5 years
  // Data for the graph
  final RxList<int> graphData = <int>[].obs;
  @override
  void onInit() {
    super.onInit();
    graphData.assignAll(monthlyData); // Default filter is Monthly
  }
  void updateGraphData(String filter) {
    selectedFilter.value = filter;
    if (filter == 'Weekly') {
      graphData.assignAll(weeklyData);
    } else if (filter == 'Monthly') {
      graphData.assignAll(monthlyData);
    } else if (filter == 'Yearly') {
      graphData.assignAll(yearlyData);
    }
  }
}
class StudentsGraphScreen extends StatelessWidget {
  final StudentsGraphController controller = Get.put(StudentsGraphController());
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: SizedBox(
        height: Get.height * 0.55,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 10),
          child: Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.,
                children: [
                  const Text(
                    "Student Enrollment",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Spacer(),
                  // Dropdown for filter
                  Obx(
                          () => Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.orangeAccent, // Custom border color
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white, // Background color
                        ),
                        child: DropdownButton<String>(
                          value: controller.selectedFilter.value,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                          borderRadius: BorderRadius.circular(15),
                          underline: SizedBox(),
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
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.updateGraphData(value);
                            }
                          },
                        ),
                      )
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Line graph
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
                              if (controller.selectedFilter.value == 'Weekly' && index >= 0 && index < 7) {
                                return Text(
                                  ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][index],
                                  style: const TextStyle(fontSize: 12),
                                );
                              } else if (controller.selectedFilter.value == 'Monthly' && index >= 0 && index < 12) {
                                return Text(
                                  ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][index],
                                  style: const TextStyle(fontSize: 12),
                                );
                              } else if (controller.selectedFilter.value == 'Yearly' && index >= 0 && index < 5) {
                                return Text(
                                  ['2019', '2020', '2021', '2022', '2023'][index],
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
                          spots: controller.graphData
                              .asMap()
                              .entries
                              .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
                              .toList(),
                          isCurved: true,
                          color: Colors.deepOrange,
                          barWidth: 1.5,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: true,),
                          // gradient: LinearGradient(colors: [Colors.white,Colors.blue],
                          // end: Alignment.bottomLeft,
                          // begin: Alignment.centerRight)
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