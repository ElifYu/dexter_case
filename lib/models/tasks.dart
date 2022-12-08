import 'package:cloud_firestore/cloud_firestore.dart';

class Tasks {
  DateTime timeSent;
  String choosedHour;//*
  String content;//*
  String title;//*
  String whichShift;//
  String uid;
  bool done;//*
  // doc id
  String id;
  String senderProfilePhoto;
  String senderName;


  Tasks({
    required this.timeSent,
    required this.choosedHour,
    required this.content,
    required this.title,
    required this.whichShift,
    required this.uid,
    required this.done,
    required this.id,
    required this.senderProfilePhoto,
    required this.senderName,
  });

  Map<String, dynamic> toJson() => {
    'timeSent': timeSent.millisecondsSinceEpoch,
    'choosedHour': choosedHour,
    'content': content,
    'title': title,
    'whichShift': whichShift,
    'uid': uid,
    'done': done,
    'id': id,
    'senderProfilePhoto': senderProfilePhoto,
    'senderName': senderName,

  };

  static Tasks fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Tasks(
      timeSent:  DateTime.fromMillisecondsSinceEpoch(snapshot['timeSent']),
      choosedHour: snapshot['choosedHour'],
      content: snapshot['content'],
      title: snapshot['title'],
      whichShift: snapshot['whichShift'],
      uid: snapshot['uid'],
      done: snapshot['done'],
      id: snapshot['id'],
      senderName: snapshot['senderName'],
      senderProfilePhoto: snapshot['senderProfilePhoto'],
    );
  }
}
