import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icon.dart';

import '../../constants.dart';

Widget commonInput(
{
  required Icon prefixIcon,
  required String hintText,
  required TextEditingController controller,
  required TextInputType keyBoardTyp,
  required bool obsText,
}) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      color: bgGrey,
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.all(Radius.circular(7)),

    ),
    child: Center(
      child: TextField(
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
        obscureText: obsText,
        keyboardType: keyBoardTyp,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[600]
          )

        ),
      ),
    ),
  );
}

Widget commonInputSecond(
    {
      required Icon prefixIcon,
      required String hintText,
      required TextEditingController controller,
      required TextInputType keyBoardTyp,
      required bool obsText,
    }) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      color: bgGrey,
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.all(Radius.circular(7)),

    ),
    child: Center(
      child: TextField(
        obscureText: obsText,
        keyboardType: keyBoardTyp,
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: prefixIcon,
            hintText: hintText,
            hintStyle: TextStyle(
                color: Colors.grey[600]
            )

        ),
      ),
    ),
  );
}


Widget taskInputs(
    {
      required String hintText,
      required TextEditingController controller,
      required int maxLines,
    }) {
  return Container(
    height: maxLines == 2 ?
    50 : 100,
    decoration: BoxDecoration(
      color: bgGrey,
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.all(Radius.circular(7)),
    ),
    padding: EdgeInsets.only(left: 20),
    child: Center(
      child: TextField(
        maxLines: maxLines,
        keyboardType: TextInputType.text,
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
                color: Colors.grey[600]
            )

        ),
      ),
    ),
  );
}