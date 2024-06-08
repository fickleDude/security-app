import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:safety_app/UI/widgets/text_field_widget.dart';
import 'package:safety_app/logic/providers/emergency_chat_provider.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import 'package:uuid/uuid.dart';

import '../../../logic/services/location_service.dart';
import '../../domain/chat_message_model.dart';

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
    Provider.of<EmergencyChatProvider>(context, listen: false)
        .sendMessage(widget.recipientId, message);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextField(
                  // textAlign: TextAlign.center,
                  cursorColor: primaryColor,
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: 'введи сообщение',
                      hintStyle: context.subtitlePrimary,
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
                            Icons.add,
                            size: 40,
                            color: accentColor,
                            weight: 80,
                          )),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:  BorderSide(
                            style: BorderStyle.solid,
                            color: primaryColor
                        ),
                  ),
                      enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:  BorderSide(
                          style: BorderStyle.solid,
                          color: primaryColor
                      ),
                    ),
                ),

          ),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async{
                    ChatMessageModel message = ChatMessageModel(
                        date: DateTime.now(),
                        type: 'text',
                        message: _controller.text);
                    Provider.of<EmergencyChatProvider>(context, listen: false)
                        .sendMessage(widget.recipientId, message);
                    _controller.clear();
                  },
                  child: Icon(
                    Icons.send,
                    color: accentColor,
                    size: 40,
                    weight: 80,
                  ),
                ),
              ),
            ],
          )

      ),
    );
  }

  Widget _bottomSheet(){
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        // image: const DecorationImage(
        //   image: AssetImage("assets/bottom_sheet.png"),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _chatsIcon(Icons.location_pin, "локация",
                  () async {
            String? messageBody = await _locationService.getOnMap();
            ChatMessageModel message = ChatMessageModel(date: DateTime.now(), type: 'link', message: messageBody);
            if(messageBody != null){
              Provider.of<EmergencyChatProvider>(context, listen: false)
                  .sendMessage(widget.recipientId, message);
            }else{
              Fluttertoast.showToast(
                  msg: "невозможно определить местоположение");
            }
          }),
          _chatsIcon(Icons.camera_alt, "камера", () async{
            await getImageFromCamera();
          }
          ),
          _chatsIcon(Icons.photo, "фото", () async{
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
            // radius: 50,
            backgroundColor: Colors.transparent,
            child: Icon(icons, color: fillColor,
              size: 50,
              weight: 100,),
          ),
          const SizedBox(height: 8,),
          Text(title, style: context.subtitleAccent,)
        ],
      ),
    );
  }

}