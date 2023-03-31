import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_voice_assistant/pallete.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String hText;
  final descriptionT;
  const FeatureBox(
      {super.key,
      required this.color,
      required this.hText,
      required this.descriptionT});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20).copyWith(left: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                hText,
                style: TextStyle(
                    fontFamily: "Cera Pro",
                    color: Pallete.blackColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                descriptionT,
                style: TextStyle(
                  fontFamily: "Cera Pro",
                  color: Pallete.blackColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
