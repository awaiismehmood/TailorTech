import 'package:dashboard/Model_Classes/tailor_class.dart';
import 'package:dashboard/Tailor_views/Profile/edit_profile.dart';
import 'package:dashboard/Tailor_views/chat/chat_home.dart';
import 'package:dashboard/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatefulWidget {
  final Tailor tailor;

  const EditProfileScreen({required this.tailor, super.key});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.put(AuthController());

  final PageController _controller = PageController();
  int _currentPosition = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPosition = _controller.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.red,
          ),
          child: ListView(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: widget.tailor.profile_url != " "
                        ? NetworkImage(widget.tailor.profile_url)
                        : null,
                    child: widget.tailor.profile_url == " "
                        ? Icon(Icons.person)
                        : null,
                  ),
                  title: Text(
                    widget.tailor.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    widget.tailor.email,
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage()),
                      );
                    },
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                ),
              ),
              SizedBox(height: 10), // Reduced the space
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      tileColor: Colors.red[200],
                      title: Text(
                        'Catalog',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Container(
                            height: 200,
                            width: double.infinity,
                            child: PageView.builder(
                              controller: _controller,
                              itemCount: widget.tailor.images.length,
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Image.network(
                                  widget.tailor.images[index],
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 1),
                          Center(
                            child: DotsIndicator(
                              dotsCount: widget.tailor.images.length,
                              position: _currentPosition,
                              decorator: DotsDecorator(
                                color: Colors.grey,
                                activeColor: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      tileColor: Colors.red[200],
                      title: Text(
                        'Account',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'CNIC',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        widget.tailor.cnic,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Phone Number',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        widget.tailor.phone,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Rating',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          RatingBar(
                            rating: widget.tailor.ratting,
                            onRatingChanged: (double ratting) {},
                          ),
                          SizedBox(width: 10),
                          Text(
                            widget.tailor.ratting.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      tileColor: Colors.red[200],
                      title: Text(
                        'Settings',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.chat),
                      title: Text(
                        'Chat',
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => chatHomeT()),
                        );
                        // Add functionality for Chat
                      },
                    ),
                    // ListTile(
                    //   leading: Icon(Icons.notifications),
                    //   title: Text(
                    //     'Notifications',
                    //     style: TextStyle(fontSize: 14),
                    //   ),
                    //   onTap: () {
                    //     // Add functionality for Notifications
                    //   },
                    // ),
                    ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text(
                        'Sign Out',
                        style: TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        controller.signoutmethod(context, "Tailor");
                        // Add functionality for Sign Out
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final double rating;
  final Function(double) onRatingChanged;
  RatingBar({required this.rating, required this.onRatingChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star, color: rating >= 1 ? Colors.red : Colors.grey),
        Icon(Icons.star, color: rating >= 2 ? Colors.red : Colors.grey),
        Icon(Icons.star, color: rating >= 3 ? Colors.red : Colors.grey),
        Icon(Icons.star, color: rating >= 4 ? Colors.red : Colors.grey),
        Icon(Icons.star, color: rating == 5 ? Colors.red : Colors.grey),
      ],
    );
  }
}
