import 'dart:convert';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/utils/shared_preference/shared_preference_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LeaderboardController extends GetxController {
  var users = [].obs; // No specific model, storing raw list data
  var isLoading = true.obs;
  RxString userId = "".obs;
  var leaderboard = [].obs;
  var filteredLeaderboard = [].obs;
  var selectedCriteria = 'user_name'.obs;

  void filterLeaderboard({required String query}) {
    if (query.isEmpty) {
      filteredLeaderboard.assignAll(leaderboard); // Reset to original list
    } else {
      filteredLeaderboard.assignAll(
        leaderboard.where((student) {
          // Cast student to Map<String, dynamic>
          final studentMap = student as Map<String, dynamic>;
          final value = studentMap[selectedCriteria.value].toString().toLowerCase();
          return value.contains(query.toLowerCase());
        }),
      );
    }
  }

  void clearSearch() {
    filteredLeaderboard.assignAll(leaderboard); // Reset to original list
  }

  @override
  void onInit() {
    fetchLeaderboardData();
    super.onInit();
  }

  // Get user ID from local storage
  Future<String?> getUserId() async {
    return await getDataFromLocalStorage(
      dataType: "STRING",
      prefKey: "user_id",
    ) as String?;
  }

  fetchLeaderboardData() async {
    isLoading.value = true;
    userId.value = await getUserId() ?? '';

    if (userId.value.isEmpty || userId.value == "null") {
      print("User ID not found in local storage.");
      isLoading.value = false;
      return;
    }

    try {
      final Map<String, dynamic> body = {
        "user_id": userId.value,
      };

      final response = await http.post(
        Uri.parse(ApiString.getLeaderboard),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('URL: ${ApiString.getLeaderboard}');
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('data') && data['data'] is List) {
          leaderboard.value = List<Map<String, dynamic>>.from(data['data']);
          filteredLeaderboard.assignAll(leaderboard);
        } else {
          print("Data key not found in response.");
        }
      } else {
        print("Failed to fetch leaderboard: ${response.body}");
      }
    } catch (e) {
      print("Error fetching leaderboard: $e");
    } finally {
      isLoading.value = false;
    }
  }

  searchLeaderboardData(String search_query) async {
    isLoading.value = true;
    userId.value = await getUserId() ?? '';

    if (userId.value.isEmpty || userId.value == "null") {
      print("User ID not found in local storage.");
      isLoading.value = false;
      return;
    }

    try {
      final Map<String, dynamic> body = {
        "user_id": userId.value,
        "user_id": userId.value,
      };

      final response = await http.post(
        Uri.parse(ApiString.search_student),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('URL: ${ApiString.getLeaderboard}');
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('data') && data['data'] is List) {
          leaderboard.value = List<Map<String, dynamic>>.from(data['data']);
        } else {
          print("Data key not found in response.");
        }
      } else {
        print("Failed to fetch leaderboard: ${response.body}");
      }
    } catch (e) {
      print("Error fetching leaderboard: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
