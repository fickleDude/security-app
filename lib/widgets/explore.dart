import 'package:flutter/cupertino.dart';
import 'package:safety_app/utils/ui_theme_extension.dart';

import '../components/custom_slider.dart';
import '../utils/quotes.dart';

class ExploreWidget extends StatelessWidget{
  const ExploreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text(
                "EXPLORE",)
        ),
        CustomSlider(
            articleImage: articleImages,
            articleSource: articleSources,
            articleTitle: articleTitles
        ),
      ],
    );
  }

}