import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SingleMessage extends StatelessWidget{
  final String? message;
  final bool? isMe;
  final String? image;
  final String? recipientName;
  final String? userName;
  final String? type;
  final Timestamp? date;

  const SingleMessage({
    super.key,
    this.message,
    this.isMe,
    this.image,
    this.recipientName,
    this.userName,
    this.type,
    this.date
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return type=='text'
    ? Container(
      constraints: BoxConstraints(
        maxWidth: size.width / 2,
      ),
      alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.all(10),
      child: Container(
          decoration: BoxDecoration(
            color: isMe! ? primaryColor : defaultColor,
            borderRadius: border(isMe!),
          ),
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: size.width / 2,
          ),
          alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
          child: content(Text(
            message!,
            style: context.b2,
          ))),
    )
    : type=='img'
    ? Container(
      width: size.width,
      height: size.height/2,
      alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.all(10),
      child: Container(
          width: size.width,
          height: size.height/2.5,
          decoration: BoxDecoration(
            color: isMe! ? primaryColor : defaultColor,
            borderRadius: border(isMe!),
          ),
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: size.width / 2,
          ),
          alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
          child: content(CachedNetworkImage(
            imageUrl: message!,
            fit: BoxFit.cover,
            width: size.width,
            height: size.height/4,
            placeholder: (context,url)=>const CircularProgressIndicator(),
            errorWidget: (context,url, error)=>const Icon(Icons.error),
          ))),
    )
    : Container(
      constraints: BoxConstraints(
        maxWidth: size.width / 2,
      ),
      alignment: isMe! ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.all(10),
      child: Container(
          decoration: BoxDecoration(
            color: isMe! ? primaryColor : defaultColor,
            borderRadius: border(isMe!)
          ),
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: size.width / 2,
          ),
          alignment:
          isMe! ? Alignment.centerRight : Alignment.centerLeft,
          child: content(GestureDetector(
            onTap: () async {
              await launchUrl(Uri.parse("$message"));
            },
            child: Text(
              message!,
              style: context.b2,
            ),
          ))),
    );
  }

  BorderRadius border(bool side){
    return side
        ? const BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
      bottomLeft: Radius.circular(15),
    )
        : const BorderRadius.only(
      topLeft: Radius.circular(15),
      topRight: Radius.circular(15),
      bottomRight: Radius.circular(15),
    );
  }

  Column content(Widget message){
    DateTime d = DateTime.parse(date!.toDate().toString());
    String cdate = d.minute.toInt() < 10
        ? "${d.hour}:0${d.minute.toInt()}"
        : "${d.hour}:${d.minute}";
    return Column(
      children: [
        Align(
            alignment: Alignment.centerRight,
            child: Text(
              isMe! ? userName! : recipientName!,
              style: GoogleFonts.firaCode(fontSize: 11, color: CupertinoColors.white),
            )),
        const Divider(),
        Align(
            alignment: Alignment.centerRight,
            child: message),
        const Divider(),
        Align(
            alignment: Alignment.centerRight,
            child: Text(
              cdate,
              style: GoogleFonts.firaCode(fontSize: 11, color: CupertinoColors.white),
            )),
      ],
    );
  }
}