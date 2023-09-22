// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:ai_assistant/chat_bubble.dart';
import 'package:ai_assistant/colors.dart';
import 'package:ai_assistant/openai_service.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var messages = [];
  bool isbtnEnable = true;
  IconData _icon = Icons.mic;
  final speechToText = SpeechToText();

  var nameText = TextEditingController();
  ScrollController _scrollController = ScrollController();

  String lastWords = '';
  final openAIService = OpenAIService();
  final pallete = Pallete();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<String> startListening() async {
    final completer = Completer<String>();
    speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          completer.complete(result.recognizedWords);
        }
      },
    );
    return completer.future;
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void animate() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  Future<void> messagebox(String userText) async {
    messages.add({'text': userText, 'me': true, 'isImage': false});
    animate();
    nameText.clear();
    isbtnEnable = false;
    setState(() {});
    Timer(Duration(milliseconds: 200), () {
      messages.add({'text': 'Typing...', 'me': false, 'isImage': false});
      animate();
      setState(() {});
    });

    final result = await openAIService.isArtPromptApI(userText);
    if (result.contains('https:')) {
      await messages.removeLast();
      animate();
      messages.add({'text': result, 'me': false, 'isImage': true});
      isbtnEnable = true;
      animate();
      setState(() {});
    } else {
      await messages.removeLast();
      setState(() {});
      messages.add({'text': result, 'me': false, 'isImage': false});
      isbtnEnable = true;
      animate();
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechToText.stop();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ZoomIn(
            child: MenuAnchor(
                style: MenuStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blueGrey.shade900)),
                builder: (context, controller, child) {
                  return IconButton(
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: Icon(Icons.menu),
                    color: Colors.white,
                  );
                },
                menuChildren: List.generate(
                    1,
                    (index) => MenuItemButton(
                        onPressed: () {
                          setState(() {
                            messages.clear();
                          });
                        },
                        child: Text(
                          'Clear chat',
                          style: TextStyle(color: Colors.white),
                        ))))),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BounceInDown(
              child: Text(
                'Ai Chat',
                style: TextStyle(color: Colors.white, fontFamily: 'Cera Pro'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 90),
              child: ZoomIn(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(30, 11, 20, 147),
                          shape: BoxShape.circle),
                    ),
                    SizedBox(
                        height: 45,
                        width: 50,
                        child: Image.asset('assets/images/bot.png'))
                  ],
                ),
              ),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (index == messages.length) {
                    return SizedBox(
                      height: 50,
                    );
                  }
                  return IntrinsicWidth(
                    child: Row(
                      mainAxisAlignment: messages[index]['me'] == true
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        messages[index]['me'] == true
                            ? FadeInUp(child: ChatBubble(messages, index))
                            : FadeInLeft(child: ChatBubble(messages, index))
                      ],
                    ),
                  );
                },
                itemCount: messages.length + 1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 260,
                    // margin: EdgeInsets.only(right: 20),
                    child: TextField(
                      controller: nameText,
                      onChanged: (value) {
                        setState(() {});
                      },
                      cursorColor: Colors.white70,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: 'Write your message',
                          hintStyle: TextStyle(color: Colors.white24),
                          fillColor: const Color.fromARGB(30, 0, 17, 249),
                          filled: true,
                          contentPadding: EdgeInsets.all(10),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color: const Color.fromARGB(30, 0, 17, 249))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                  color:
                                      const Color.fromARGB(30, 0, 17, 249)))),
                    )),
                ZoomIn(
                  delay: Duration(milliseconds: 600),
                  child: ElevatedButton(
                    onPressed: isbtnEnable
                        ? () async {
                            var userText = nameText.text.toString();
                            if (userText == '') {
                              if (await speechToText.hasPermission &&
                                  speechToText.isNotListening) {
                                setState(() {
                                  _icon = Icons.stop;
                                });
                                final result = await startListening();
                                setState(() {
                                  _icon = Icons.mic;
                                });
                                await messagebox(result);
                              } else {
                                _icon = Icons.mic;
                                setState(() {});
                                await stopListening();
                              }
                            } else {
                              await messagebox(userText);
                            }
                          }
                        : null,
                    // ignore: sort_child_properties_last
                    child: Icon(
                      nameText.text.toString() == '' ? _icon : Icons.send,
                      // size: 25,
                      color: Colors.black54,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pallete.mainFontColor,
                      disabledBackgroundColor: Colors.blueGrey.shade800,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(12),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
