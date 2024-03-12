//import 'package:dashboard/Permissions/Location_Perm.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Model_Classes/tailor_class.dart';
import 'package:dashboard/Tailor_views/order_confirmation/Orders.dart';
import 'package:dashboard/Tailor_views/order_list/order_history.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:dashboard/widgets_common/exercise_tile.dart';
import 'package:dashboard/widgets_common/emotion_face.dart';
import 'package:flutter/material.dart';

class HomePage_Tailor extends StatefulWidget {
  final Tailor tailor;
  const HomePage_Tailor({super.key, required this.tailor});

  @override
  State<HomePage_Tailor> createState() => _HomePageTailorState();
}

class _HomePageTailorState extends State<HomePage_Tailor> {
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate =
        "${currentDate.day}-${currentDate.month}-${currentDate.year}";
    return Scaffold(
      backgroundColor: redColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    //greeting row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi ${widget.tailor.name}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: redColor,
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    // search bar

                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: darkFontGrey,
                          borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Search",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),

                    // how do you feel
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "How do you feel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),

                    // 4 different
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //bad
                        Column(
                          children: [
                            EmotionFace(emotionFace: "😃"),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Happy",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            EmotionFace(emotionFace: "😞"),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Sad",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            EmotionFace(emotionFace: "🙃"),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Confused",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            EmotionFace(emotionFace: "😇"),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "blessed",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Container(
                    padding: EdgeInsets.all(25),
                    color: Colors.grey[200],
                    child: Center(
                      child: Column(
                        children: [
                          //Exercises
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Menu",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Icon(Icons.more_horiz),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //list view of exercises
                          Expanded(
                            child: ListView(
                              children: [
                                ExerciseTile(
                                  onpress: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrderHistory()));
                                  },
                                  icon: Icons.miscellaneous_services,
                                  exerciseName: "Order List",
                                  numberOfExercises: 10,
                                  color: Colors.orange,
                                ),
                                ExerciseTile(
                                  onpress: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrderAcceptScreen()));
                                  },
                                  icon: Icons.more,
                                  exerciseName: "Order Confirmation",
                                  numberOfExercises: 10,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
