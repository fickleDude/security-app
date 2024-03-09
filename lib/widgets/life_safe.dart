import 'package:flutter/material.dart';
import 'package:safety_app/utils/constants.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class LifeSafeWidget extends StatelessWidget {
  const LifeSafeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text('EXPLORE LIFE SAFE', style: context.prT2)),
        SizedBox(
          height: 90,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              //police
              _LifeSafeIcon(
                  location: 'police station near me',
                  assetImage: 'assets/police-badge.png',
                  title: 'Police Station'),
              //hospital
              _LifeSafeIcon(
                  location: 'hospitals near me',
                  assetImage: 'assets/hospital.png',
                  title: 'Hospital Station'),
              //bus station
              _LifeSafeIcon(
                  location: 'bus stations near me',
                  assetImage: 'assets/bus-stop.png',
                  title: 'Bus Station'),
              //pharmacy
              _LifeSafeIcon(
                  location: 'pharmacies near me',
                  assetImage: 'assets/pharmacy.png',
                  title: 'Pharmacies'),
            ],
          ),
        )
      ],
    );
  }
}

class _LifeSafeIcon extends StatelessWidget {
  final String _baseURL = "https://www.google.com/maps/search/";

  String location;
  String assetImage;
  String title;

  _LifeSafeIcon(
      {required this.location, required this.assetImage, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              String googleUrl = _baseURL + location;
              final Uri url = Uri.parse(googleUrl);
              try {
                await launchUrl(url);
              } catch (e) {
                if (context.mounted) {
                  dialog(context, e.toString());
                }
              }
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                width: 50,
                height: 50,
                child: Center(
                  child: Image(
                    image: AssetImage(assetImage),
                    height: 32,
                  ),
                ),
              ),
            ),
          ),
          Text(title)
        ],
      ),
    );
  }
}
