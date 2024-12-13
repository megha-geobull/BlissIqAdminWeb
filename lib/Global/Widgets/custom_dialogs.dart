// Common Dialogs


import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialogs {
  void showCircularDialog(
    BuildContext context,
  ) {
    CircularDialog.showLoadingDialog(
      context,
    );
  }

  void hideCircularDialog(
    BuildContext context,
  ) {
    Navigator.pop(
      context,
    );
  }

  getDialog({
    String title = "Error",
    String desc = "Some Thing went wrong...",
  }) {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: title,
      content: Text(
        desc,
        textAlign: TextAlign.center,
      ),
      buttonColor: AppColor.hexGrey,
      textConfirm: "Ok",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
      },
    );
  }
}

class CircularDialog {
  static Future<void> showLoadingDialog(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return WillPopScope(
          child: Center(
            child: CircularProgressIndicator(
              color: AppColor.hexGrey,
            ),
          ),
          onWillPop: () async {
            return false;
          },
        );
      },
      barrierDismissible: false,
    );
  }
}
