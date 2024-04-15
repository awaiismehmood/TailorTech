// ignore_for_file: unused_local_variable

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dashboard/chat/common/enums/msg_enum.dart';
import 'package:dashboard/chat/features/chat/widgets/videoplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_message_package/voice_message_package.dart';

class Displaytextimagegif extends ConsumerStatefulWidget {
  final String message;
  final Color color;

  final Messageenum messageenum;
  const Displaytextimagegif(
      {super.key,
      required this.color,
      required this.message,
      required this.messageenum});

  @override
  ConsumerState<Displaytextimagegif> createState() =>
      _DisplaytextimagegifState();
}

class _DisplaytextimagegifState extends ConsumerState<Displaytextimagegif> {
  @override
  Widget build(BuildContext context) {
    bool isplaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();

    return widget.messageenum == Messageenum.text
        ? Text(
            widget.message,
            style: const TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.start,
          )
        : widget.messageenum == Messageenum.audio
            ? SizedBox(
                width: 350,
                child: VoiceMessageView(
                  activeSliderColor: Colors.grey,
                  innerPadding: 5,
                  size: 30,
                  backgroundColor: widget.color,
                  controller: VoiceController(
                      audioSrc: widget.message,
                      maxDuration: const Duration(seconds: 360),
                      isFile: false,
                      onComplete: () {},
                      onPause: () {},
                      onPlaying: () async {
                        //   _audioPlayer.getDuration();
                        //  showsnackbar(context, 'playing');
                      }),
                ),
              )

            // StatefulBuilder(
            //   builder: (context,setState) {
            //     return IconButton(onPressed: () async{
            //       if(isplaying){
            //         await _audioPlayer.pause();
            //         setState((){
            //          isplaying=false;
            //         });
            //       }
            //       else{
            //         await _audioPlayer.play(UrlSource(message));
            //          setState((){
            //          isplaying=true;
            //         });
            //       }
            //     }, icon: Icon(isplaying?Icons.pause_circle: Icons.play_circle));
            //   }
            // )
            : widget.messageenum == Messageenum.video
                ? videoplayeritem(videourl: widget.message)
                : CachedNetworkImage(
                    imageUrl: widget.message,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
  }
}
