import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomCard extends StatelessWidget {
  String? currentAddress;
  String? currentPosition;

  CustomCard(this.currentPosition,this.currentAddress, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showBottomSheet(context),
      child: Card(
        margin: const EdgeInsets.all(25.0),
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: ListTile(
                  title: Text("Send location"),
                  subtitle: Text("Share location"),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/route.jpg'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height / 1.4,
              decoration:
                  BoxDecoration(color: gradientColorBright.withOpacity(0.5)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('POSITION: ${currentPosition ?? ""}'),
                  Text('ADDRESS: ${currentAddress ?? ""}'),
                ],
              ));
        });
  }

}
