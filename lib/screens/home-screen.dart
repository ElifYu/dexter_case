import 'package:dexter_task/common/widgets/show-dialog.dart';
import 'package:dexter_task/constants.dart';
import 'package:dexter_task/controllers/shifts/task_controller.dart';
import 'package:dexter_task/screens/add-update-task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import 'package:line_icons/line_icon.dart';
import 'dart:math' as math;

import 'package:line_icons/line_icons.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );

    taskController.getInShiftTasks();
    authController.getUserInf().then((value) {
     setState(() {
       print(value);
     });
    });
    tabController.addListener(() {
      if(tabController.index == 0) {
        taskController.getInShiftTasks();
      } if(tabController.index == 1) {
        taskController.orderInShiftTasks(whichShift: "morning");
      }
      if(tabController.index == 2) {
        taskController.orderInShiftTasks(whichShift: "evening");
      }
      if(tabController.index == 3) {
        taskController.orderInShiftTasks(whichShift: "night");
      }
      if(tabController.index == 4) {
        taskController.orderAllCompletedShiftTasks();
      }
    });
  }


  List<String> allTabBarItem = [
    "All",
    "Morning Shifts",
    "Evening Shifts",
    "Night Shifts",
    "Completed",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddTaskInShifts())!.then((value) {
           setState(() {
             tabController.notifyListeners();
           });
          });
        },
        backgroundColor: appColor,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
            length: 5,
            child: CustomScrollView(slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.only(top: 10, left: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ListTile(
                      minLeadingWidth: 0,
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.all(0),
                      leading: authController.userModel == null ?
                       CircleAvatar(
                         radius: 40,
                         backgroundColor: Colors.grey[300],
                         child: CircularProgressIndicator(color: Colors.grey[400], strokeWidth: 2,),
                       ) :
                       CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(authController.userModel!.profilePhoto),
                      ),
                      title:  authController.userModel == null ? Text("Your Name", style: TextStyle(
                        color: Colors.grey[300]
                      ),) :
                      Text(authController.userModel!.name),
                      trailing: IconButton(
                        icon: LineIcon.alternateSignOut(color: Colors.grey[700],),
                        onPressed: (){
                          authController.signOut();
                        },
                      ),
                      subtitle: authController.userModel == null ? Text("Joined:", style: TextStyle(
                          color: Colors.grey[300]
                      ),) : Row(
                        children: [
                          Text("Joined: " + authController.user.metadata.creationTime!.day.toString() + "/"
                              + authController.user.metadata.creationTime!.month.toString() + "/"
                              + authController.user.metadata.creationTime!.year.toString()),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text("•"),
                          ),
                          Text(toBeginningOfSentenceCase(authController.userModel!.selectedShift)!, style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500
                          ),),
                        ],
                      ),
                    )
                ),
              ),
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: Colors.white,
                toolbarHeight: 30,
                bottom: TabBar(
                  onTap: (value){
                    print(value);
                  },

                  indicatorColor: appColor,
                  indicatorWeight: 3,
                  isScrollable: true,
                  controller: tabController,
                  tabs: allTabBarItem.map((e) {
                    return Tab(
                      child: Padding(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        child: Text(e.toString(), style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400
                        ),),
                      ),
                    );
                  }).toList()
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: tabController,
                  physics: BouncingScrollPhysics(),
                  children: allTabBarItem.map((e) {
                    return Obx(() {
                      return Container(
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          color: Color(0xFFEFF3F6),
                          child: taskController.tasks.isEmpty ?
                          Container() :
                          ListView.builder(
                              itemCount: taskController.tasks.length,
                              itemBuilder: (BuildContext context, int index){
                                var data = taskController.tasks[index];
                                return GestureDetector(
                                  onTap: (){
                                    showModalBottomSheetCustom(
                                      context: context,
                                      profileImage: data.senderProfilePhoto,
                                      userName: data.senderName,
                                      createdTime:
                                          DateFormat.LLL().format(data.timeSent) + " " +
                                          DateFormat.d().format(data.timeSent)  + ", " +
                                          DateFormat.EEEE().format(data.timeSent),
                                        createdHour: DateFormat.Hm().format(data.timeSent),
                                        content: data.content,
                                        title: data.title,
                                        whichShift: data.whichShift,
                                       choosedHour: data.choosedHour,
                                        done: data.done,
                                        id: data.id,
                                      complete: () {
                                        taskController.updateInShiftTask(
                                          title: data.title,
                                          content: data.content,
                                          choosedDate: data.choosedHour,
                                          whichShift: data.whichShift,
                                          timeSent: data.timeSent,
                                          done: true,
                                          id: data.id,
                                          userUid: authController.user.uid,
                                        ).then((value) {
                                          setState(() {
                                            Navigator.pop(context);
                                            tabController.notifyListeners();
                                          });
                                        });
                                      },

                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          children: [
                                            Text(DateFormat.EEEE().format(data.timeSent).substring(0, 4).toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey[500],
                                                fontSize: 15,
                                              ),),
                                            Text(DateFormat.d().format(data.timeSent),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17,
                                                  color: Colors.grey[900]
                                              ),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                            margin: EdgeInsets.only(left: 10, right: 12, top: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                left: BorderSide(
                                                  color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                                                  width: 3.0,
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(data.title, style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 17
                                                        ), maxLines: 1,),
                                                      ),
                                                      Spacer(),
                                                      Text(DateFormat.Hm().format(data.timeSent),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w400,
                                                            color: Colors.grey[500]
                                                        ),),
                                                    ],
                                                  ),
                                                  SizedBox(height: 7,),
                                                  Text(data.content, style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey[600]
                                                  ), maxLines: 1),
                                                  SizedBox(height: 6),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        color: Colors.blueAccent.withOpacity(0.1),
                                                        padding: EdgeInsets.all(5),
                                                        margin: EdgeInsets.only(top: 7, right: 15),
                                                        child: Text(toBeginningOfSentenceCase(data.whichShift)!,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.blueAccent
                                                          ),),
                                                      ),
                                                      Container(
                                                        color: Colors.purple.withOpacity(0.1),
                                                        padding: EdgeInsets.all(5),
                                                        margin: EdgeInsets.only(top: 7, right: 15),
                                                        child: Text(data.choosedHour,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w400,
                                                              color: Colors.purple
                                                          ),),
                                                      ),
                                                      Spacer(),
                                                      CircleAvatar(
                                                        backgroundImage: NetworkImage(data.senderProfilePhoto),
                                                      )

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          )
                      );
                    });
                  }).toList()
                ),
              ),
            ])),
      )
    );
  }
}
