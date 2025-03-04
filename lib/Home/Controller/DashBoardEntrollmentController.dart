
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../Global/constants/ApiString.dart';
import '../../Global/constants/common_snackbar.dart';
import '../../Global/utils/shared_preference/shared_preference_services.dart';
import '../Drawer/models/EnrollmentModel.dart';
import '../Drawer/models/NotificationModel.dart';

class DashBoardController extends GetxController {
  // Dropdown values
  final selectedFilter = 'Weekly'.obs; // Changed default to Weekly for demo
  // Reactive data for the graph
  final RxList<int> graphData = <int>[].obs;
  final RxList<String> graphLabels = <String>[].obs; // To store dynamic labels
  RxBool isLoading = false.obs;
  // Parsed JSON data
  late Enrollmentmodel enrollmentData ;
  RxList<NotificationData> notifications =<NotificationData>[].obs;

  @override
  void onInit() {
    super.onInit();
    enrollmentData = Enrollmentmodel.fromJson({
      "status": 1,
      "weekly_counts": {"Sunday": 0, "Monday": 0, "Tuesday": 0, "Wednesday": 0, "Thursday": 0, "Friday": 0, "Saturday": 0},
      "monthly_counts": {"Week-1": 0, "Week-2": 0, "Week-3": 0, "Week-4": 0},
      "yearly_counts": {"Jan": 0, "Feb": 0, "Mar": 0, "Apr": 0, "May": 0, "Jun": 0, "Jul": 0, "Aug": 0, "Sep": 0, "Oct": 0, "Nov": 0, "Dec": 0},
      "last_5_years_counts": {"2025": 0, "2024": 0, "2023": 0, "2022": 0, "2021": 0},
      "students": 0.0,
      "mentors": 0.0,
      "schools": 0.0,
      "companies": 0.0,
    });
    getAllEnrollments();
    getNotifications(userType:'Student');// Fetch data asynchronously
  }

  void updateGraphData(String filter) {
    selectedFilter.value = filter;
    if (filter == 'Weekly') {
      graphData.assignAll(enrollmentData.weeklyCounts.values.toList());
      graphLabels.assignAll(enrollmentData.weeklyCounts.keys.toList());
    } else if (filter == 'Monthly') {
      graphData.assignAll(enrollmentData.monthlyCounts.values.toList());
      graphLabels.assignAll(enrollmentData.monthlyCounts.keys.toList());
    } else if (filter == 'Yearly') {
      graphData.assignAll(enrollmentData.yearlyCounts.values.toList());
      graphLabels.assignAll(enrollmentData.yearlyCounts.keys.toList());
    } else if (filter == 'Last 5 Years') {
      graphData.assignAll(enrollmentData.last5YearsCounts.values.toList());
      graphLabels.assignAll(enrollmentData.last5YearsCounts.keys.toList());
    }
  }

  getAllEnrollments() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(ApiString.get_enrollment_students),
        headers: {"Content-Type": "application/json"},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 1) {

          enrollmentData = Enrollmentmodel.fromJson(responseData);

          // Set initial data
          updateGraphData('Weekly');
        } else {
          showSnackbar(message: "Failed to fetch complaints");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching category $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  addNotification({
    required String title,
    required String notification,
    required String userType,
  }) async {
    isLoading.value = true;
    final String? userId = await getUserId();

    if (userId == null || userId.isEmpty) {
      print("User ID not found. $userId");
      return;
    }

    try {
      final Uri url = Uri.parse(ApiString.add_notifications);
      var request = http.MultipartRequest('POST', url)
        ..fields['title'] = title
        ..fields['descriptions'] = notification
        ..fields['user_type'] = userType;

      // Send the request
      var response = await request.send();
      final responseData = await http.Response.fromStream(response);

      // Handle server response
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(responseData.body);
        if (jsonResponse['status'] == 1) {
          // Successfully updated profile
          //await getProfile();
          showSnackbar(message: "Notification Send");
        } else {
          // Profile update failed
          showSnackbar(message: jsonResponse['message'] ?? "Update failed!",
          );
        }
      } else {
        // Server returned an error
        print("Error: ${response.statusCode}, Response: ${responseData.body}");
      }
    } catch (e) {
      // Catch any errors during the process
      print("Error updating profile: $e");
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
      );
    } finally {
      // Stop loading spinner
      isLoading.value = false;
    }
  }

  getNotifications({required String userType}) async {
    isLoading.value = true;
    notifications.clear();
    try {
      final Map<String, dynamic> body = {
        "user_type": userType,
      };
      final response = await http.post(
        Uri.parse(ApiString.get_notifications),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Url: ${ApiString.get_notifications}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 1) {
          notifications.value = (responseData["data"] as List)
              .map((notificationsJson) => NotificationData.fromJson(notificationsJson))
              .toList();
        } else {
          showSnackbar(message: "Failed to fetch notifications");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching notifications $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  delete_notification({required String notificationID}) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "notification_auto_id": notificationID,
      };

      final response = await http.delete(
        Uri.parse(ApiString.delete_notification),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Response url: ${ApiString.delete_notification}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          showSnackbar(message: "Notification deleted successfully");
        } else {
          showSnackbar(message: "Failed to delete Notification");
        }
      }
    } catch (e) {
      showSnackbar(message: "Error while delete $e");
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Get user ID from local storage
  getUserId() async {
    return await getDataFromLocalStorage(
      dataType: "STRING",
      prefKey: "user_id",
    ) as String?;
  }
}