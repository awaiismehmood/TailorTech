import 'dart:io';
import 'package:dashboard/chat/common/widgets/utility/utils.dart';
import 'package:dashboard/chat/features/chat/controller/chat_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../colors.dart';
import '../../../common/enums/msg_enum.dart';

class bottomchatscreen extends ConsumerStatefulWidget {
  final String recieverUserid;
  const bottomchatscreen({
    super.key,
    required this.recieverUserid,
  });

  @override
  ConsumerState<bottomchatscreen> createState() => _bottomchatscreenState();
}

class _bottomchatscreenState extends ConsumerState<bottomchatscreen> {
  bool isshowsendbutton = false;
  final _messagecontroller = TextEditingController();
  bool isshowemojicontainer = false;
  FocusNode focusNode = FocusNode();
  bool isRecorderinit = false;
  FlutterSoundRecord? _flutterSoundRecorder;
  bool isrecording = false;

  @override
  void initState() {
    _flutterSoundRecorder = FlutterSoundRecord();
    openAudio();
    super.initState();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // final status = await Permission.microphone.request();
    } else {
      await _flutterSoundRecorder!.start();
      isRecorderinit = true;
    }
  }

  void showkeyboard() => focusNode.requestFocus();
  void hidekeyboard() => focusNode.unfocus();

  void hideemojicontainer() {
    setState(() {
      isshowemojicontainer = false;
    });
  }

  void showemojicontainer() {
    setState(() {
      isshowemojicontainer = true;
    });
  }

  void toggleemojicontainer() {
    if (isshowemojicontainer) {
      showkeyboard();
      hideemojicontainer();
    } else {
      hidekeyboard();
      showemojicontainer();
    }
  }

  void sendtextmsg() async {
    if (isshowsendbutton) {
      ref.watch(ChatcontrollerProvider).sendtextmsg(
            context: context,
            Text: _messagecontroller.text.trim(),
            receiveruid: widget.recieverUserid,
          );
      setState(() {
        _messagecontroller.text = '';
      });
    } else {
      var tempdir = await getTemporaryDirectory();
      var path = '${tempdir.path}/flutter_sound';
      if (!isRecorderinit) {
        return;
      }
      if (isrecording) {
        await _flutterSoundRecorder!.stop();
        sendfilemsg(File(path), Messageenum.audio);
      } else {
        await _flutterSoundRecorder!.start(
          path: path,
        );
      }

      setState(() {
        isrecording = !isrecording;
      });
    }
  }

  void sendfilemsg(
    File file,
    Messageenum msgenum,
  ) {
    ref.read(ChatcontrollerProvider).sendfilemsg(
          context: context,
          file: file,
          receiveruid: widget.recieverUserid,
          msgenum: msgenum,
        );
  }

  void selectimage() async {
    File? image = await pickimagefromgallery(context);
    if (image != null) {
      sendfilemsg(image, Messageenum.image);
    }
  }

  void selectvideo() async {
    File? image = await pickvideofromgallery(context);
    if (image != null) {
      sendfilemsg(image, Messageenum.video);
    }
  }

  @override
  void dispose() {
    _messagecontroller.dispose();
    _flutterSoundRecorder!.dispose();
    isRecorderinit = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: _messagecontroller,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      isshowsendbutton = true;
                    });
                  } else {
                    setState(() {
                      isshowsendbutton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              toggleemojicontainer();
                            },
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.gif,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectimage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: selectvideo,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                right: 2,
                left: 2,
              ),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 25,
                child: GestureDetector(
                  onTap: sendtextmsg,
                  child: Icon(
                    isshowsendbutton
                        ? Icons.send
                        : isrecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        isshowemojicontainer
            ? SizedBox(
                height: 350,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      _messagecontroller.text =
                          _messagecontroller.text + emoji.emoji;
                    });
                    if (!isshowsendbutton) {
                      setState(() {
                        isshowsendbutton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
