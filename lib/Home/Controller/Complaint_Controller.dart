import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blissiqadmin/Global/constants/ApiString.dart';
import '../../Global/constants/common_snackbar.dart';
import '../Drawer/models/ComplaintModel.dart';

class ComplaintController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<ComplaintData> allComplaintData = <ComplaintData>[].obs;

  getAllComplaints() async {
    isLoading.value = true;
    allComplaintData.clear();
    try {
      final response = await http.post(
        Uri.parse(ApiString.get_raised_complaint),
        headers: {"Content-Type": "application/json"},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          allComplaintData.value = (responseData["data"] as List)
              .map((mentorJson) => ComplaintData.fromJson(mentorJson))
              .toList();
        } else {
          showSnackbar(message: "Failed to fetch complaints");
        }
      }else
      if (response.statusCode == 204) {
        showSnackbar(message: "No Complaints");
      }
    } catch (e) {
      showSnackbar(message: "Error while fetching Complaints $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  UpdateStatusComplaints({required String complaint_id,required String complaint_status}) async {
    isLoading.value = true;

    try {
      final Map<String, dynamic> body = {
        "complaint_id": complaint_id,
        "status": complaint_status,
      };
      final response = await http.post(
        Uri.parse(ApiString.update_complaint_status),
        headers: {"Content-Type": "application/json"},
        body:jsonEncode(body),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Url: ${ApiString.update_complaint_status}');

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == 1) {
          // Parse each JSON object into a Data model
          getAllComplaints();
        } else {
          showSnackbar(message: "Failed to update complaint status ");
        }
      }else
      if (response.statusCode == 204) {
        showSnackbar(message: "No Complaints");
      }
    } catch (e) {
      showSnackbar(message: "Error while updating complaint status $e");
      log(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

}