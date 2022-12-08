import 'package:dexter_task/common/widgets/buttons.dart';
import 'package:dexter_task/constants.dart';
import 'package:dexter_task/screens/log-in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({Key? key}) : super(key: key);

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> with TickerProviderStateMixin{
  AnimationController? _breathingController;
  var _breathe =0.0;


  @override
  void initState() {
    super.initState();

    _breathingController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _breathingController!.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _breathingController!.reverse();

      } else if (status == AnimationStatus.dismissed){
        _breathingController!.forward();
      }
    });

    _breathingController!.addListener(() {
      setState(() {
        _breathe =_breathingController!.value;
      });
    });
    _breathingController!.forward();
  }


  @override
  dispose() {
    _breathingController!.dispose(); // you need this
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = 450.0 -60.0 * _breathe;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[

          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).size.height * 0.1)),
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                height: size,
                width:size,
                  child: Image.asset("assets/heart.png")),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.3,
                            child: Column(
                              children: [
                                Text("App for nurses", style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28,
                                ),),
                                SizedBox(height: 10),
                                Text(loremIpsumText,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black54
                                  ),textAlign: TextAlign.center, )
                              ],
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
                          Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: appButton("Get Started", appColor, (){
                                Get.offAll(LoginScreen());
                              })),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
