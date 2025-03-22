// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';



class Functions {
  static final _firestore = FirebaseFirestore.instance;

  /// Delete multiple users and their associated chat rooms
  static Future<void> deleteUsers({required String userIds}) async {
    log("Deleting multiple users and their associated data...");
    try {
      List<String> userIdList = userIds.split('|');

      for (String userId in userIdList) {
        userId = userId.trim();
        if (userId.isNotEmpty) {
          await _firestore.collection('Users').doc(userId).delete();
          await _firestore.collection('msgReq').doc(userId).delete();
          await _firestore.collection('Rooms').doc(userId).delete();
          log("Deleted user from firebase: $userId");
        }
      }
      log("All specified users and related data deleted successfully.");
    } catch (e) {
      log("Error deleting users: $e");
    }
  }


}



