import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class videoplayeritem extends StatefulWidget {
  final String videourl;

  const videoplayeritem({super.key, required this.videourl});

  @override
  State<videoplayeritem> createState() => _videoplayeritemState();
}

class _videoplayeritemState extends State<videoplayeritem> {
  late VideoPlayerController _videoPlayerController;
  bool isplay = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _videoPlayerController =
        VideoPlayerController.network((widget.videourl))
       
          ..initialize().then((_) {
            _videoPlayerController.setVolume(1);
             print(widget.videourl);
          });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          VideoPlayer(_videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if(isplay){
                   _videoPlayerController.pause();
                }
                else{
                  _videoPlayerController.play();
                }
                setState(() {
                  isplay=!isplay;
                });
              },
              icon: Icon(
                 isplay? Icons.pause_circle: Icons.play_circle,
                size: 16,
              ),


            ),
          ),
        ],
      ),
    );
  }
}
