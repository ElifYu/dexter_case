
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_task/controllers/shifts/task_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth/auth_controller.dart';

// COLORS
const Color appColor = Color(0xFFD53F52);
const Color bgGrey = Color(0xFFF3F5F6);

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var fireStore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;
TasksController taskController = Get.put(TasksController());

//
String loremIpsumText = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.";

//
 bool emailValid(email) {
   return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
 }

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}