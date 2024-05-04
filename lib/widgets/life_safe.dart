import 'package:flutter/material.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LifeSafeWidget extends StatelessWidget {
  const LifeSafeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return  Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          _LifeSafeIcon(
              location: 'police station near me',
              assetImage: 'assets/police_point.png',
              color: backgroundColor,
              title: 'полиция',
              titleStyle:context.subtitlePrimary,
          ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 130),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                Text("поиск", style: context.subtitleAccent),
                Text("по", style: context.subtitlePrimary),
                Text("карте", style: context.subtitleAccent),
              ],),
            )

        ],),
        Row(children: [
          SizedBox(width: width/5),
          _LifeSafeIcon(
              location: 'hospitals near me',
              assetImage: 'assets/hospital_point.png',
              color: accentColor,
              title: 'больница',
              titleStyle: context.subtitlePrimary,
          ),
          SizedBox(width: width/10),
          _LifeSafeIcon(
              location: 'bus stations near me',
              assetImage: 'assets/bus_point.png',
              color: backgroundColor,
              title: 'остановка',
              titleStyle: context.subtitlePrimary,
          )
        ],),
        Row(children: [
          SizedBox(width: width/2.5),
          _LifeSafeIcon(
              location: 'pharmacies near me',
              assetImage: 'assets/pharmacy_point.png',
              color: accentColor,
              title: 'аптека',
              titleStyle: context.subtitlePrimary,
          )
        ],)
        ],
      ),
    );
  }
}

class _LifeSafeIcon extends StatelessWidget {
  final String _baseURL = "https://www.google.com/maps/search/";

  String location;
  String assetImage;
  String title;
  TextStyle? titleStyle;
  Color color;

  _LifeSafeIcon({
    required this.location,
    required this.assetImage,
    required this.color,
    required this.title,
    this.titleStyle
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
      String googleUrl = _baseURL + location;
      final Uri url = Uri.parse(googleUrl);
      try {
        await launchUrl(url);
      } catch (e) {
        Fluttertoast.showToast(msg: "не получается загрузить карту");
      }
      },
      child: Column(children: [
        Image(
          image: AssetImage(assetImage),
          height: 100,
        ),
        Container(
            alignment: Alignment.center,
            width: 120,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(30))
            ),
            child: Text(title, style: titleStyle,)
        )
        ],
      ),
    );
  }
}
