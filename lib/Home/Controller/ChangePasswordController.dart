import 'dart:convert';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import 'package:blissiqadmin/Global/utils/shared_preference/shared_preference_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordController extends GetxController {
  final isLoading = false.obs;

  RxString userId = "".obs;
  RxBool passwordVisible = false.obs;


  @override
  void onInit() {
    super.onInit();
    _loadUserId();
  }

  getUserId() async {
    return await getDataFromLocalStorage(
      dataType: "STRING",
      prefKey: "user_id",
    ) as String?;
  }

  Future<void> _loadUserId() async {
    userId.value = await getUserId();
    if (userId.isEmpty) {
      Fluttertoast.showToast(msg: "User ID not found in preferences.");
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (userId.isEmpty) {
      Fluttertoast.showToast(msg: "User ID not found. Please log in again.");
      return false;
    }

    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "user_id": userId.value,
        "old_password": oldPassword,
        "new_password": newPassword,
        "confirm_password": confirmPassword,
      };

      final response = await http.post(
        Uri.parse(ApiString.changePassword),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 1) {
          Fluttertoast.showToast(msg: responseData['message'] ?? "Password changed successfully!");
          return true;
        } else {
          Fluttertoast.showToast(msg: responseData['message'] ?? "Something went wrong!");
          return false;
        }
      } else {
        Fluttertoast.showToast(msg: "Something went wrong!");
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
