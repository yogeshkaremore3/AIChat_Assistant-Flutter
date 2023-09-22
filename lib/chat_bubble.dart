// ignore_for_file: must_be_immutable

import 'package:ai_assistant/colors.dart';
import 'package:ai_assistant/screens/detail_screen.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  // const ChatBubble({super.key});
  var index;
  var messages;
  final pallete = Pallete();

  ChatBubble(messages, index) {
    this.index = index;
    this.messages = messages;
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          constraints: messages[index]['me'] == false
              ? BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7)
              : BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.2,
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: messages[index]['me'] == false
                ? Color.fromARGB(30, 0, 17, 249)
                : pallete.mainFontColor,
            borderRadius: messages[index]['me'] == true
                ? BorderRadius.circular(15).copyWith(topRight: Radius.zero)
                : BorderRadius.circular(15).copyWith(topLeft: Radius.zero),
          ),
          child: Center(
              child: messages[index]['isImage'] == false
                  ? SelectableText(
                      '${messages[index]['text']}',
                      style: TextStyle(
                          color: messages[index]['me'] == true
                              ? Colors.black87
                              : Colors.white,
                          fontFamily: 'Cera Pro'),
                    )
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailsImage(
                                    imageUrl: '${messages[index]['text']}')));
                      },
                      child: Hero(
                        tag: '${messages[index]['text']}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            '${messages[index]['text']}',
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.blue,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ))),
    );
  }
}
