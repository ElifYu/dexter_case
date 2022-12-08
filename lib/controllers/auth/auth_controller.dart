import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_task/constants.dart';
import 'package:dexter_task/models/user.dart';
import 'package:dexter_task/screens/home-screen.dart';
import 'package:dexter_task/screens/log-in.dart';
import 'package:dexter_task/models/device-token.dart';
import 'package:dexter_task/models/user.dart' as model;
import 'package:dexter_task/screens/onboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late Rx<File?> _pickedImage;

  File? get profilePhoto => _pickedImage.value;
  User get user => _user.value!;



  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(firebaseAuth.currentUser);
    _user.bindStream(firebaseAuth.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  _setInitialScreen(User? user) async{
    await Future.delayed(Duration(seconds: 2)).then((value) {
      if (user == null) {
        Get.offAll(() => OnBoardPage());
      } else {
        FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
        _firebaseMessaging.getToken().then((token){
          print("token is $token");
          UserDeviceToken.deviceTokenOfUser = token!;
          Get.offAll(() => HomeScreen());
        });
      }
    });
  }

  Future pickImage() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture!');
    }
    _pickedImage = Rx<File?>(File(pickedImage!.path));
    return _pickedImage;
  }

  // upload to firebase storage
  Future<String> _uploadToStorage(File image) async {
    Reference ref = firebaseStorage
        .ref()
        .child('profilePics')
        .child(firebaseAuth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // registering the user
  void registerUser(
      String username, String email, String password, File? image, String selectedShift) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        Get.snackbar(
          'Creating',
          "Please wait, your account is creating.",
        );
        // save out user to our ath and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String downloadUrl = await _uploadToStorage(image);
        model.UserModel user = model.UserModel(
            name: username,
            email: email,
            uid: cred.user!.uid,
            profilePhoto: downloadUrl,
            userDeviceToken: UserDeviceToken.deviceTokenOfUser,
            selectedShift: selectedShift
        );
        await fireStore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Creating Account',
        e.toString(),
      );
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Log in',
        e.toString(),
      );
    }
  }

  UserModel? userModel;
  Future<UserModel?> getUserInf() async{
   final data =  await fireStore
        .collection('users')
        .doc(authController.user.uid)
        .get().then((DocumentSnapshot value) {
          print(value);
          userModel = UserModel.fromSnap(value);
          return userModel;
        });
   return data;
  }
  void signOut() async {
    await firebaseAuth.signOut();

  }
}