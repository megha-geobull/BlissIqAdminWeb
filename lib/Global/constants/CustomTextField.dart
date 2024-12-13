import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'AppColor.dart';


class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool alignLabelWithHint;
  final Widget? prefixIcon;
  final bool filled;
  final Widget? sufixIcon;
  final Function(String)? onChanged;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final int maxLines;
  CustomTextField({
    required this.controller,
    required this.labelText,
    this.hintText,
    this.onSubmitted,
    this.alignLabelWithHint = false,
    this.prefixIcon,
    this.onChanged,
    this.filled = false,
    this.sufixIcon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLength,
    this.inputFormatters,
    this.readOnly = false,
    this.maxLines = 1,
  }) : assert(!obscureText || maxLines == 1, 'Obscured fields cannot be multiline.');


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 50,
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        validator: validator,
        onChanged: onChanged,
        maxLines: maxLines,
        cursorColor: AppColor.grey,
         readOnly: readOnly,
        onFieldSubmitted: onSubmitted,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          alignLabelWithHint: alignLabelWithHint,
          prefixIcon: prefixIcon,
          suffixIcon: sufixIcon,
          hintStyle: TextStyle(color: AppColor.grey,fontWeight: FontWeight.normal,fontSize: 13),
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 14.0,
            //  fontWeight: FontWeight.w500,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 0.8),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.8),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 14.0, horizontal: 16.0),
        ),


      ),
    );
  }
}
