import 'package:dexter_task/common/widgets/buttons.dart';
import 'package:dexter_task/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

import '../../screens/add-update-task.dart';

showModalBottomSheetCustom({
  required BuildContext context,
  required String profileImage,
  required String userName,
  required String createdTime,
  required String createdHour,
  required String title,
  required String content,
  required String whichShift,
  required String choosedHour,
  required bool done,
  required String id,
  required VoidCallback complete,
}) {
  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            padding: EdgeInsets.only(bottom: 20, left: 20, right: 10, top: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(profileImage),
                          ),
                          title: Text(userName),
                          subtitle: Text(createdTime),
                          trailing: Text(createdHour),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Divider(),
                        ),
                        Row(
                          children: [
                            Container(
                              color: Colors.blueAccent.withOpacity(0.1),
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(top: 7, right: 15),
                              child: Text(toBeginningOfSentenceCase(whichShift)!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.blueAccent
                                ),),
                            ),
                            Container(
                              color: Colors.purple.withOpacity(0.1),
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(top: 7, right: 15),
                              child: Text(choosedHour,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.purple
                                ),),
                            ),
                          ],
                        ),
                        SizedBox(height: 25,),
                        Text(title, style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17
                        )),

                        SizedBox(height: 15,),
                        Text(content, style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600]
                        )),
                        SizedBox(height: 6),
                      ],
                    ),
                  ),
                ),

                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: appColor.withOpacity(0.7))
                      ),
                      margin: EdgeInsets.all(5),
                      child: IconButton(
                        icon: Icon(LineIcons.edit, color: appColor.withOpacity(0.7)),
                          onPressed: (){
                            Get.to(AddTaskInShifts(
                                isUpdate: "yes",
                                title: title,
                                content: content,
                                choosedDate: choosedHour,
                                whichShift: whichShift,
                                done: done,
                                id: id,
                                userUid: authController.user.uid
                            ));
                          },
                      )
                    ),
                    Expanded(
                      child: completeButton("Complete", appColor, (){
                        complete();
                      }),
                    ),
                  ],
                ),

              ],
            ),
          ),
        );
      }
  );
}