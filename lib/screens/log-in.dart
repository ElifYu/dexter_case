import 'package:dexter_task/common/widgets/buttons.dart';
import 'package:dexter_task/common/widgets/input.dart';
import 'package:dexter_task/constants.dart';
import 'package:dexter_task/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Welcome Again! 👋", style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25
                ),),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
                  child: Text(loremIpsumText, style: TextStyle(
                    fontSize: 16,
                     color: Colors.black54
                  ),),
                ),
                commonInput(
                 obsText: false,
                 keyBoardTyp: TextInputType.emailAddress,
                  hintText: 'Email Address',
                  prefixIcon: LineIcon.envelope(),
                  controller: emailController
                ),
                const SizedBox(
                  height: 25,
                ),
                commonInput(
                    obsText: true,
                    keyBoardTyp: TextInputType.visiblePassword,
                    hintText: 'Password',
                    prefixIcon: LineIcon.lock(),
                    controller: passwordController
                ),
                const SizedBox(
                  height: 30,
                ),
                appButton("Sign In", appColor, (){
                  if(emailValid(emailController.text)){
                    if(passwordController.text.length >= 6){
                      authController.loginUser(
                        emailController.text,
                        passwordController.text,
                      );
                    } else{
                      Get.snackbar("Wrong password", "Please enter your correct password.");
                    }
                  }
                  else{
                    Get.snackbar("Not email", "Enter your email address correctly.");
                  }

                }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600]
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ),
                      ),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            fontSize: 19,
                            color: appColor,
                        fontWeight: FontWeight.bold),
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
