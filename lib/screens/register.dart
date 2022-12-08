import 'dart:io';

import 'package:dexter_task/common/widgets/buttons.dart';
import 'package:dexter_task/common/widgets/input.dart';
import 'package:dexter_task/constants.dart';
import 'package:dexter_task/screens/log-in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';


class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  Rx<File?>? image;

  @override
  void dispose() {
    super.dispose();
    shiftKey = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.grey
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
                Center(
                  child: Stack(
                    children: [
                      image != null ?  CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(image!.value!),
                        backgroundColor: appColor.withOpacity(0.5),
                      ) : CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png'),
                        backgroundColor: appColor.withOpacity(0.5),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 50,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white54,
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: IconButton(
                            onPressed: () => authController.pickImage().then((value) {
                              setState(() {
                                print(value.runtimeType);
                                image = value;
                              });
                            }),
                            icon: const Icon(
                              Icons.add_a_photo,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                commonInputSecond(
                    obsText: false,
                    keyBoardTyp: TextInputType.text,
                    hintText: 'Name & Surname *',
                    prefixIcon: LineIcon.user(),
                    controller: usernameController
                ),
                const SizedBox(
                  height: 15,
                ),
                commonInput(
                    obsText: false,
                    keyBoardTyp: TextInputType.emailAddress,
                    hintText: 'Email Address *',
                    prefixIcon: LineIcon.envelope(),
                    controller: emailController
                ),
                const SizedBox(
                  height: 15,
                ),
                commonInput(
                    obsText: true,
                    keyBoardTyp: TextInputType.visiblePassword,
                    hintText: 'Password min 6 character *',
                    prefixIcon: LineIcon.lock(),
                    controller: passwordController
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  '• Please select your shift *',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600]
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    selectShift("Morning", LineIcon.sun(), "morning", setState),
                    selectShift("Evening", LineIcon.cloudWithMoon(), "evening", setState),
                    selectShift("Night", LineIcon.moon(), "night", setState),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                appButton("Sign Up", appColor, (){
                  if(image != null && usernameController.text.isNotEmpty && shiftKey != ""){
                    if(passwordController.text.length >= 6){
                      if(emailValid(emailController.text)){
                        authController.registerUser(
                            usernameController.text,
                            emailController.text,
                            passwordController.text,
                            authController.profilePhoto,
                            shiftKey
                        );
                      }
                      else{
                        Get.snackbar("Not email", "Enter an email address.");
                      }
                    }
                    else{
                      Get.snackbar("Password Less than 6 characters", "Your password is less than 6 characters");
                    }
                  }
                  else{
                    Get.snackbar("Fill in all fields", "Please fill in all fields.");
                  }
                }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Do you have an account? ',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600]
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                              fontSize: 19,
                              color: appColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
