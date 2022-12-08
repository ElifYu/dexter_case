import 'package:flutter/material.dart';

Widget addNewTaskTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 13, bottom: 13, left: 10),
    child: Text(text, style: TextStyle(
        fontSize: 15,
        color: Colors.grey[500]
    ),),
  );
}