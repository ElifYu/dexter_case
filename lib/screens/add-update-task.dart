import 'package:dexter_task/common/widgets/buttons.dart';
import 'package:dexter_task/common/widgets/input.dart';
import 'package:dexter_task/common/widgets/text-style.dart';
import 'package:dexter_task/constants.dart';
import 'package:dexter_task/controllers/shifts/task_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';

class AddTaskInShifts extends StatefulWidget {
  final String? isUpdate;
  final String? title;
  final String? content;
  final String? choosedDate;
  final String? whichShift;
  final bool? done;
  final String? id;
  final String? userUid;

  const AddTaskInShifts({Key? key, this.isUpdate, this.title, this.content, this.choosedDate, this.whichShift, this.done, this.id, this.userUid}) : super(key: key);

  @override
  State<AddTaskInShifts> createState() => _AddTaskInShiftsState();
}

class _AddTaskInShiftsState extends State<AddTaskInShifts> {

  TextEditingController controllerContent = TextEditingController();

  TextEditingController controllerTitle = TextEditingController();

  var pickedTime;

  bool isDone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isUpdate == "yes"){
      controllerTitle = TextEditingController(text: widget.title);
      controllerContent = TextEditingController(text: widget.content);
      pickedTime = widget.choosedDate!;
      shiftKey = widget.whichShift!;
      isDone = widget.done!;
      print(widget.done);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.isUpdate == "yes" ? "Update Task" :
          "New Task", style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600
        ),),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.black87
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
               widget.isUpdate == "yes" ?  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        CupertinoSwitch(
                          value: isDone,
                          onChanged: (bool? value) {
                            // This is called when the user toggles the switch.
                            setState(() {
                              isDone = value!;
                              print(value);
                            });
                          },
                        ),
                        Text("Mark done", style: TextStyle(
                            color: Colors.grey
                        ),)
                      ],
                    ),
                  ],
                ) :
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                addNewTaskTitle("Title"),
                taskInputs(
                  maxLines: 2,
                    controller: controllerTitle,
                    hintText: "Enter title"),
                addNewTaskTitle("Content"),
                taskInputs(
                  maxLines: 5,
                    controller: controllerContent,
                    hintText: "Enter Content"),

                SizedBox(height: 25),
                Text("Description", style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500]
                ),),
                SizedBox(height: 8),


                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select time for this task", style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17
                    ),),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () async{
                        TimeOfDay initialTime = TimeOfDay.now();
                         pickedTime = await showTimePicker(
                          context: context,
                          initialTime: initialTime,
                        ).then((value) {
                          if(value != null){
                            setState(() {
                              pickedTime = value;
                            });
                            return pickedTime.format(context);
                          }
                           return pickedTime;
                         });
                        print(pickedTime);
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: bgGrey,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                        padding: EdgeInsets.only(right: 20, left: 20),
                        child: Center(
                          child: pickedTime == null ?
                          Text("00:00", style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[500]
                          ),) : Text(pickedTime!.toString(), style: TextStyle(
                            color: appColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600
                          ),)
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 28),
                Text(
                  '• Select shift for this task*',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 17
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                appButton(
                  widget.isUpdate == "yes" ? "Update task" :
                    "Create a new task", appColor, () async{
                    if(controllerTitle.text.isNotEmpty &&
                    controllerContent.text.isNotEmpty &&
                    pickedTime != null && shiftKey != "") {
                      if(widget.isUpdate == "yes"){
                        print("yes");
                        final done = await taskController.updateInShiftTask(
                          title: controllerTitle.text,
                          content: controllerContent.text,
                          choosedDate: pickedTime!.toString(),
                          whichShift: shiftKey,
                          timeSent: DateTime.now(),
                          done: isDone,
                          id: widget.id.toString(),
                          userUid: widget.userUid.toString(),
                        ).then((value) {
                          Navigator.pop(context);
                        });
                        print(done);
                      }
                      else{
                        final done = taskController.postInShiftNewTask(
                          title: controllerTitle.text,
                          content: controllerContent.text,
                          choosedDate: pickedTime!.toString(),
                          whichShift: shiftKey,
                          timeSent: DateTime.now(),
                          done: false,
                        ).then((value) {
                          Navigator.pop(context);
                        });

                      }
                    }
                    else{
                      Get.snackbar("Fill in all fields", "Please fill in all fields.");
                    }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
