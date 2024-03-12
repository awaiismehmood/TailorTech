import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/Customer_views/home_screen/home.dart';
import 'package:dashboard/consts/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class TailorShow extends StatefulWidget {
  final String orderId;
  final String tailorId;
  const TailorShow({super.key, required this.orderId, required this.tailorId});

  @override
  State<TailorShow> createState() => _TailorShowState();
}

class _TailorShowState extends State<TailorShow> {
  final double coverHeight = 280;

  final double profileHeight = 144;

  List imageList = [
    {"id": 1, "image_path": 'assets/images/slider_1.png'},
    {"id": 2, "image_path": 'assets/images/slider_2.png'},
    {"id": 3, "image_path": 'assets/images/slider_3.png'},
    {"id": 4, "image_path": 'assets/images/slider_4.png'},
  ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildTop(),
          buildContent(),

          SizedBox(
            height: 70,
          ),

          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  // ignore: deprecated_member_use
                  primary: Colors.red,
                  padding: const EdgeInsets.all(12)),
              onPressed: () {
                _confirmOrder(widget.tailorId);
                Get.offAll(Home());
              },
              child:
                  "Place Order".text.color(whiteColor).fontFamily(bold).make()),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: sliderImage(),
          // ),
        ],
      ),
    );
  }

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 50,
        ),
        const Text(
          "Tailor name",
          style: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, fontFamily: bold),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          "only male Tailor",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black.withOpacity(0.4),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        // Divider(
        //   color: whiteColor,
        // ),
        const SizedBox(
          height: 10,
        ),

        buildAbout(),
        SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget buildAbout() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Rattings',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                fontFamily: semibold),
          ),
          SizedBox(
            height: 10,
          ),
          rattings(),
          // Text(
          //   'blah blah blha...',
          //   style: TextStyle(fontSize: 18, height: 1.4),
          // ),
        ],
      ),
    );
  }

  Widget buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom), child: sliderImage()),
        Positioned(top: top, child: buildProfileImage()),
      ],
    );
  }

  // Widget buildCoverImage() => Container(
  //       color: Colors.grey,
  //       child: Image.asset(
  //         "assets/images/Tailor12.jpg",
  //         width: double.infinity,
  //         height: coverHeight,
  //         fit: BoxFit.cover,
  //       ),
  //     );

  Widget buildProfileImage() => CircleAvatar(
        radius: profileHeight / 2,
        backgroundColor: whiteColor,
        backgroundImage: AssetImage("assets/images/Tailor.jpg"),
      );

  Widget sliderImage() {
    return Column(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: () {
                print(currentIndex);
              },
              child: CarouselSlider(
                items: imageList
                    .map(
                      (item) => Image.asset(
                        item['image_path'],
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    )
                    .toList(),
                carouselController: carouselController,
                options: CarouselOptions(
                    scrollPhysics: const BouncingScrollPhysics(),
                    autoPlay: true,
                    aspectRatio: 1.5,
                    autoPlayInterval: const Duration(seconds: 4),
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    }),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imageList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => carouselController.animateToPage(entry.key),
                    child: Container(
                      width: currentIndex == entry.key ? 17 : 7,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 3.0,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: currentIndex == entry.key
                              ? Colors.red
                              : Colors.teal),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget rattings() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemPadding: EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: redColor,
                  ),
              onRatingUpdate: (ratting) {
                print(ratting);
                print(widget.tailorId);
              })
        ],
      ),
    );
  }

  void _confirmOrder(String tailorId) async {
    // Update the tailorId field in the order
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .update({
      'expectedTailorId': tailorId,
    });
  }
}
