import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String profilePhoto;
  String email;
  String uid;
  String userDeviceToken;
  String selectedShift;

  UserModel(
      {required this.name,
        required this.userDeviceToken,
        required this.email,
        required this.uid,
        required this.selectedShift,
        required this.profilePhoto});

  Map<String, dynamic> toJson() => {
    "name": name,
    "profilePhoto": profilePhoto,
    "email": email,
    "uid": uid,
    "selectedShift": selectedShift,
    "userDeviceToken": userDeviceToken,
  };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      email: snapshot['email'],
      profilePhoto: snapshot['profilePhoto'],
      uid: snapshot['uid'],
      name: snapshot['name'],
      selectedShift: snapshot['selectedShift'],
      userDeviceToken: snapshot['userDeviceToken'],
    );
  }
}

