import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class customAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleName;
  final void Function()? onTap;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Color? textColor;
  final double? textSize;
  final bool automaticallyImplyLeading;
  final double? toolbarHeight;

  customAppBar({
    this.titleName,
    this.onTap,
     this.backgroundColor,
    this.actions,
    this.textColor,
    this.textSize,
    required this.automaticallyImplyLeading,
    this.toolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor??Colors.white,
      automaticallyImplyLeading: automaticallyImplyLeading,
      scrolledUnderElevation: 0,
      flexibleSpace: Container(
        color: Colors.white,
      ),
      leadingWidth: 45,
      toolbarHeight: toolbarHeight ?? 48.0,
      title: Align(
        alignment: titleName != null && titleName!.isNotEmpty
            ? Alignment.centerLeft
            : Alignment.center,
        child: Text(
          titleName ?? "",
          style: TextStyle(
            color: textColor ?? Colors.black,
            fontSize: textSize ?? 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      elevation: 4, // Slight elevation for better depth, adjustable
      actions: actions?.map((action) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: action,
      )).toList() ?? [], // Add actions if provided
      leading: InkWell(
        onTap: onTap ?? () => Navigator.pop(Get.context!), // Default back action
        child: Icon(
          Icons.arrow_back,
          size: 22,
          color: textColor ?? Colors.black, // Default icon color if no textColor is passed
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);
}

