import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dexter_task/constants.dart';
import 'package:dexter_task/models/tasks.dart';
import 'package:get/get.dart';


class TasksController extends GetxController {
  final Rx<List<Tasks>> _tasks = Rx<List<Tasks>>([]);
  List<Tasks> get tasks => _tasks.value;


  getInShiftTasks() async {
   try{
     _tasks.bindStream(
       fireStore
           .collection('Shifts').where("done", isEqualTo: false)
           .snapshots()
           .map(
             (QuerySnapshot query) {
           List<Tasks> retValue = [];
           for (var element in query.docs) {
             element.id;
             retValue.add(Tasks.fromSnap(element));
           }
           return retValue;
         },
       ),
     );
   } catch (e){
     Get.snackbar(
       'Error While Tasking',
       e.toString(),
     );
   }
  }

  Future<String?> postInShiftNewTask({
    required String choosedDate,
    required String content,
    required DateTime timeSent,
    required String title,
    required String whichShift,
    required bool done,
}) async {
    try {

      Get.snackbar(
        'Wait',
        "Please wait, your new task is sending",
      );
      var docId =  await fireStore
          .collection("Shifts")
          .doc()
          .id;


      Tasks shift = Tasks(
        uid: authController.user.uid,
        choosedHour: choosedDate,
        content: content,
        timeSent: timeSent,
        title: title,
        whichShift: whichShift,
        done: done,
        id: docId,
        senderProfilePhoto: authController.userModel!.profilePhoto,
        senderName: authController.userModel!.name,

      );
      await fireStore
          .collection('Shifts').doc(docId)
          .set(shift.toJson());
      return "Done";
    } catch (e) {
      Get.snackbar(
        'Error While Tasking',
        e.toString(),
      );
    }
  }


  Future<String?> updateInShiftTask({
    required String choosedDate,
    required String content,
    required DateTime timeSent,
    required String title,
    required String whichShift,
    required String userUid,
    required bool done,
    required String id,
  }) async {
    try {
      Get.snackbar(
        'Wait',
        "Please wait, your task is updating",
      );
      Tasks shift = Tasks(
          uid: userUid,
          choosedHour: choosedDate,
          content: content,
          timeSent: timeSent,
          title: title,
          whichShift: whichShift,
          done: done,
          id: id,
          senderProfilePhoto: authController.userModel!.profilePhoto.toString(),
          senderName: authController.userModel!.name.toString(),
      );
      await fireStore
          .collection('Shifts')
          .doc(id)
          .update(shift.toJson());
      return "Done";
    } catch (e) {
      Get.snackbar(
        'Error While Tasking',
        e.toString(),
      );
    }
  }


  orderInShiftTasks({
  required String whichShift
}) async {
    try{
      _tasks.bindStream(
        fireStore
            .collection('Shifts')
            .where("whichShift", isEqualTo: whichShift)
            .where("done", isEqualTo: false)
            .snapshots()
            .map(
              (QuerySnapshot query) {
            List<Tasks> retValue = [];
            for (var element in query.docs) {
              retValue.add(Tasks.fromSnap(element));
            }
            return retValue;
          },
        ),
      );
    } catch (e){
      Get.snackbar(
        'Error While Tasking',
        e.toString(),
      );
    }
  }


  orderAllCompletedShiftTasks() async {
    try{
      _tasks.bindStream(
        fireStore
            .collection('Shifts')
            .where("done", isEqualTo: true)
            .snapshots()
            .map(
              (QuerySnapshot query) {
            List<Tasks> retValue = [];
            for (var element in query.docs) {
              retValue.add(Tasks.fromSnap(element));
            }
            return retValue;
          },
        ),
      );
    } catch (e){
      Get.snackbar(
        'Error While Tasking',
        e.toString(),
      );
    }
  }

}
