// ignore_for_file: use_key_in_widget_constructors, sort_child_properties_last, prefer_const_constructors, prefer_const_literals_to_create_immutables, no_logic_in_create_state

import 'dart:typed_data';
import 'package:ai_assistant/colors.dart';
import 'package:animate_do/animate_do.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class DetailsImage extends StatefulWidget {
  final String imageUrl;
  const DetailsImage({this.imageUrl = ''});

  @override
  State<DetailsImage> createState() => DetailsImageState(imageUrl);
}

class DetailsImageState extends State<DetailsImage> {
  final String imageUrl;

  DetailsImageState(this.imageUrl);
  bool isdownload = false;
  final pallete = Pallete();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        actions: [
          ZoomIn(
            child: PopupMenuButton(
              color: Colors.blueGrey.shade900,
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                    onTap: () async {
                      var response = await Dio().get(imageUrl,
                          options: Options(responseType: ResponseType.bytes));
                      final result = await ImageGallerySaver.saveImage(
                          Uint8List.fromList(response.data),
                          quality: 100,
                          name: "Aichat_generated");
                      if (result['isSuccess'] == true) {
                        BotToast.showText(
                            text: "Saved successfully",
                            contentColor:
                                Colors.blueGrey.shade900); //popup a text toast;
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Hero(
            tag: widget.imageUrl,
            child: InteractiveViewer(child: Image.network(widget.imageUrl))),
      ),
    );
  }
}
