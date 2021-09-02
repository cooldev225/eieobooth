import 'package:flutter/material.dart';
import 'package:easyguard/public/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  final TextStyle textStyle;
  

  CustomTextField(
    {this.hint,
      this.textEditingController,
      this.keyboardType,
      this.icon,
      this.obscureText= false,
      this.textStyle,
     });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 72.sp,
decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.sp),
color: color_white
),      
      child: TextFormField(
        
        controller: textEditingController,
        keyboardType: keyboardType,
        cursorColor: color_gray,
        style: textStyle,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: new EdgeInsets.symmetric(vertical: 12.sp, horizontal: 16.sp),
          prefixIcon: Icon(icon, color: color_gray, size: 40.sp),
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.sp),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
