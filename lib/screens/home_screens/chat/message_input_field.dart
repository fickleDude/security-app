import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safety_app/logic/models/chat_message_model.dart';
import 'package:safety_app/logic/services/cloud_storage_service.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import 'package:uuid/uuid.dart';

import '../../../logic/services/location_service.dart';

class MessageInputField extends StatefulWidget{
  final String currentUserId;
  final String recipientId;
  const MessageInputField({
    super.key,
    required this.currentUserId,
    required this.recipientId
  });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField>{
  final TextEditingController _controller = TextEditingController();

  final _locationService = LocationService.instance;
  final _cloudService= CloudService.cloud;

  File? imageFile;

  Future getImage() async {
    ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.gallery).then((XFile? xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future getImageFromCamera() async {
    ImagePicker picker = ImagePicker();
    await picker.pickImage(source: ImageSource.camera).then((XFile? xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    var ref = FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");
    var uploadTask = await ref.putFile(imageFile!);
    String imageUrl = await uploadTask.ref.getDownloadURL();
    ChatMessageModel message = ChatMessageModel(date: DateTime.now(), type: 'img', message: imageUrl);
    _cloudService.sendMessage(
        widget.currentUserId,
        widget.recipientId,
        message
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                cursorColor: primaryColor,
                controller: _controller,
                decoration: InputDecoration(
                    hintText: 'type your message'.toUpperCase(),
                    fillColor: CupertinoColors.white,
                    filled: true,
                    prefixIcon: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) => _bottomSheet(),
                          );
                        },
                        icon: Icon(
                          Icons.add_box_rounded,
                          color: primaryColor,
                          size: 30,
                        ))
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async{
                  ChatMessageModel message = ChatMessageModel(date: DateTime.now(), type: 'text', message: _controller.text);
                  _cloudService.sendMessage(
                      widget.currentUserId,
                      widget.recipientId,
                      message
                  );
                  _controller.clear();
                },
                child: Icon(
                  Icons.send,
                  color: primaryColor,
                  size: 30,
                  ),
              ),
            ),
          ],
        )

      ),
    );
  }

  Widget _bottomSheet(){
    return Card(
        color: CupertinoColors.white,
        margin: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _chatsIcon(Icons.location_pin, "LOCATION", () async {
              String? messageBody = await _locationService.getOnMap();
              ChatMessageModel message = ChatMessageModel(date: DateTime.now(), type: 'link', message: messageBody);
              if(messageBody != null){
                _cloudService.sendMessage(
                    widget.currentUserId,
                    widget.recipientId,
                    message
                );
              }else{
                Fluttertoast.showToast(
                    msg: "enable define location");
              }
            }),
            _chatsIcon(Icons.camera_alt, "CAMERA", () async{
              await getImageFromCamera();
            }),
            _chatsIcon(Icons.photo, "PHOTO", () async{
              await getImage();
            }),
          ],
        ),
      );
  }

  Widget _chatsIcon(IconData icons, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: primaryColor,
            child: Icon(icons, size: 27,),
          ),
          SizedBox(height: 15,),
          Text(title, style: GoogleFonts.firaCode(fontSize: 17, color: Colors.black),)
        ],
      ),
    );
  }

}