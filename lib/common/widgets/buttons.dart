import 'package:dexter_task/constants.dart';
import 'package:dexter_task/screens/log-in.dart';
import 'package:dexter_task/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

Widget appButton(String buttonText, Color color, VoidCallback onPressed){
  return SizedBox(
    height: 55,
    child: ElevatedButton(
      child: Text(buttonText, style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20
      )),
      style: ElevatedButton.styleFrom(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // <-- Radius
        ),
        shadowColor: Colors.grey[200],
        primary: color,
      ),
      onPressed: onPressed
    ),
  );
}


Widget completeButton(String buttonText, Color color, VoidCallback onPressed){
  return SizedBox(
    height: 45,
    child: ElevatedButton(
        child: Text(buttonText, style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18
        )),
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // <-- Radius
          ),
          shadowColor: Colors.grey[200],
          primary: color,
        ),
        onPressed: onPressed
    ),
  );
}

String shiftKey = "";
Widget selectShift(String title, Icon icon, String shiftKeyName, setState){
  return InkWell(
    borderRadius: BorderRadius.all(Radius.circular(7)),
    onTap: () {
      setState((){
        shiftKey = shiftKeyName;
      });
    },
    child: Container(
      height: 55,
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color:  shiftKeyName == shiftKey ? appColor.withOpacity(0.2) : bgGrey,
        border: Border.all(color: shiftKeyName == shiftKey ? appColor.withOpacity(0.2) : Colors.grey.shade200),
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      child: Row(
        children: [
          Text(title),
          icon
        ],
      ),
    ),
  );
}