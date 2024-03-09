import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:safety_app/utils/quotes.dart';

class CustomAppBar extends StatelessWidget{
  // const CustomAppBar({super.key});

  Function? onTap;
  int? quoteIndex;

  CustomAppBar(this.quoteIndex, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
    {
      onTap!();
      },
      child: Container(
        child: Text(
          sweetSayings[quoteIndex!].toString(),
          style: TextStyle(fontSize: 22),),
      ),
    );
  }

}
