import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safety_app/logic/services/cloud_storage_service.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
                    hintText: 'type your message',
                    fillColor: backgroundColor,
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
                        ))
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async{
                  _cloudService.sendMessage(
                      widget.currentUserId,
                      widget.recipientId,
                      _controller.text,
                      'text'
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
    return Container(
      color: backgroundColor,
      height: MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.all(18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _chatsIcon(Icons.location_pin, "LOCATION", () async {
              String? messageBody = await _locationService.getOnMap();
              if(messageBody != null){
                _cloudService.sendMessage(
                    widget.currentUserId,
                    widget.recipientId,
                    messageBody,
                    'link'
                );
              }else{
                Fluttertoast.showToast(
                    msg: "enable define location");
              }
            }),
            _chatsIcon(Icons.camera_alt, "CAMERA", (){}),
            _chatsIcon(Icons.photo, "PHOTO", (){}),
          ],
        ),
      ),
    );
  }

  _chatsIcon(IconData icons, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: primaryColor,
            child: Icon(icons),
          ),
          Text(title)
        ],
      ),
    );
  }

}