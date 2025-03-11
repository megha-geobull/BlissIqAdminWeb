import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class Functions {
  static void setAvailability(
      {String? userType,
      String? name,
      String? email,
      String? phone,
      String? countryName,
      String? countryCode,
      String? userID,
      String? status,
      String? isEngaged,
      String? fcmToken}) {
    log("""
    usertype $userType
    status 
    name $name
    country $countryName
    email $email
    userID $userID
    isEngaged $isEngaged
    """);

    log("data save to firebase function called");
    final firestore = FirebaseFirestore.instance;
    final data = {
      "userId": userID,
      'name': name.toString(),
      'date_time': DateTime.now(),
      'email': email.toString(),
      "phone": phone.toString(),
      "isTyping": false,
      "status": status,
      "userType": userType,
      "isEngaged": isEngaged,
      "fcmToken": fcmToken
    };
    try {
      firestore.collection('Users').doc(userID).set(data);
    } catch (e) {
      log('setAvailability ERROR :---------------------: $e');
    }
  }

  static void updateAvailability(
      {String? userID, String? status, String? isEngaged, String? fcmToken}) {
    log("data save to firebase function called");
    final firestore = FirebaseFirestore.instance;
    final data = {
      "isTyping": false,
      "status": "Online",
      "isEngaged": isEngaged,
      "fcmToken": fcmToken
    };
    try {
      firestore.collection('Users').doc(userID).update(data);
    } catch (e) {
      log('---------------------111$e');
    }
  }

  static void updateLogoutAvailability(
      {String? userID, String? status, String? isEngaged, String? fcmToken}) {
    log("data save to firebase function called  <----> $userID");
    final firestore = FirebaseFirestore.instance;
    final data = {
      "isTyping": false,
      "status": "Offline",
      "isEngaged": "false",
      // "userType": userType,
    };
    try {
      firestore.collection('Users').doc(userID).update(data);
    } catch (e) {
      log('---------------------111$e');
    }
  }

  static void initialCreateChatRoom(
      {String? name,
      String? email,
      String? userID,
      String? chatRoomID,
      String? isEngaged}) {
    log("data save to firebase function called");
    final firestore = FirebaseFirestore.instance;
    Map<String, dynamic> data = {
      'message': "",
      'sent_by': name.toString(),
      "email": email.toString(),
      "senderID": userID,
      'datetime': DateTime.now(),
    };

    try {
      firestore.collection('Rooms').doc(userID.toString()).set(data);
      firestore.collection('Rooms').doc(userID.toString()).update({
        'users': [
          "",
          userID.toString(),
        ],
        'last_message_time': DateTime.now(),
        'last_message': "",
      });
      firestore
          .collection('Rooms')
          .doc(chatRoomID.toString())
          .collection('messages')
          .add(data);
    } catch (e) {
      log('---------------------222$e');
    }
  }

  static void setExecutiveToChatRoom(
      {String? chatRoomID,
      String? executiveID,
      String? executiveName,
      String? customerID}) {
    final firestore = FirebaseFirestore.instance;
    firestore.collection('Rooms').doc(chatRoomID.toString()).update({
      'users': [
        executiveID,
        customerID.toString(),
      ],
    });
    firestore.collection('msgReq').doc(chatRoomID.toString()).update({
      'executiveID': executiveID,
      'executiveName': executiveName,
    });
  }

  static void removeExecutiveFromChatRoom(
      {String? chatRoomID,
      String? executiveID,
      String? executiveName,
      String? customerID}) {
    final firestore = FirebaseFirestore.instance;

    log("chatRoomID.toString()  ======  ${chatRoomID.toString()}");
    firestore.collection('msgReq').doc(chatRoomID.toString()).update({
      'executiveID': "",
      'executiveName': "",
    });
    firestore.collection('Rooms').doc(chatRoomID.toString()).update({
      // 'executiveID': executiveID,
      // 'executiveName': executiveName,
      "users": [
        "",
        chatRoomID.toString(),
      ]
    });
  }

  //update notification setting
  static void updateNotificationSetting(
      {
        String? executiveID,
        String? notificationAllow
      }) {
    // showLoadingDialog();
    final firestore = FirebaseFirestore.instance;

    log("chatRoomID.toString()  ======  ${executiveID.toString()}");
    firestore.collection('Users').doc(executiveID.toString()).update({
      'all_notification': notificationAllow!.toLowerCase(),
    });
  // hideLoadingDialog();
  }

}
