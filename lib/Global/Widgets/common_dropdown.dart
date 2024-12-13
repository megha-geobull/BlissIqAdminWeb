
import 'package:blissiqadmin/Global/constants/AppColor.dart';
import 'package:blissiqadmin/Global/constants/app_text_style.dart';
import 'package:flutter/material.dart';

class CommonDropDown extends StatelessWidget {
  final String? title;
  final List? itemList;
  final String? dropDownValue;
  final String? validationMessage;
  final String? hintText;
  final double? topPadding;
  final Color? fillColor;
  final bool isTransparentColor;
  final bool needValidation;
  final String? Function(String?)? validator;
  final dynamic onTap;
  final EdgeInsets? margin;
  final dynamic boxShadow;
  final dynamic onChange;

  const CommonDropDown({
    super.key,
    this.title,
    this.itemList,
    this.dropDownValue,
    this.onChange,
    this.validator,
    this.validationMessage,
    this.topPadding,
    this.hintText,
    this.fillColor,
    this.onTap,
    this.boxShadow,
    this.margin,
    this.isTransparentColor = false,
    this.needValidation = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: topPadding ?? 0),
        if (title != null)
          Text(
            title!,
            style: AppTextStyle.semiBold.copyWith(
              fontSize: 16,
              color: AppColor.black,
            ),
          ),
        if (title != null) const SizedBox(height: 11),
        Container(
          margin: margin ?? const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            boxShadow: boxShadow == false
                ? kElevationToShadow[0]
                : [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 33,
                      spreadRadius: 0,
                      color: const Color(0xFFA7A9B7).withOpacity(0.3),
                    ),
                  ],
          ),
          child: DropdownButtonFormField(
            onTap: onTap,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              filled: true,
              isDense: true,
              fillColor: AppColor.white,
              hintText: hintText,
              contentPadding: const EdgeInsets.only(
                top: 8,
                bottom: 16,
                right: 20,
                left: 20,
              ),
              hintStyle: const TextStyle(
                color: AppColor.white,
                fontSize: 12,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:  const BorderSide(
                  color: AppColor.white,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: needValidation == true
                ? (v) {
                    if (v == null) {
                      return "$validationMessage is required!";
                    }
                    return null;
                  }
                : null,
            value: dropDownValue,
            items: itemList!.map((selectedType) {
              return DropdownMenuItem(
                value: selectedType,
                child: Text(
                  selectedType.toString(),
                  style: AppTextStyle.semiBold.copyWith(
                    fontSize: 16,
                    color: AppColor.black.withOpacity(0.5),
                  ),
                ),
              );
            }).toList(),
            isExpanded: true,
            // icon: Image.asset(
            //   ImagePath.appNameLogo,
            //   height: 7,
            //   width: 13.61,
            // ),
            onChanged: onChange,
          ),
        ),
      ],
    );
  }
}
