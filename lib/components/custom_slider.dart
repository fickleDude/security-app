import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safety_app/components/safe_webview.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

class CustomSlider extends StatelessWidget {
  final List<String> articleImage;
  final List<String> articleSource;
  final List<String> articleTitle;

  const CustomSlider({
    super.key,
    required this.articleImage,
    required this.articleSource,
    required this.articleTitle
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
            items: List.generate(
                articleImage.length,
                    (index) => _CustomerSliderItem(
                  image: articleImage[index],
                  source: articleSource[index],
                  title: articleTitle[index],
                )
            ),
            options: CarouselOptions(
              autoPlay: true, // Enable auto-play
              enlargeCenterPage: false, // Increase the size of the center item
              enableInfiniteScroll: true, // Enable infinite scroll
            )
    );
  }
}

class _CustomerSliderItem extends StatelessWidget{

  final String image;
  final String source;
  final String title;

  const _CustomerSliderItem({
    required this.image,
    required this.source,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: ()=>_navigateToRoute(
              context,
              SafeWebView(url: source)
          ),
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: 180,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(image)
                  )
              ),
            ),
          ),
        ),
        Text(title, style: context.l2,)
      ],

    );
  }

  void _navigateToRoute(BuildContext context, Widget route) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => route));
  }

}
