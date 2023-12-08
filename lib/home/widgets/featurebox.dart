import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeatureBox extends StatelessWidget {
  final Color? color;
  final String headerText;
  final String desc;
  const FeatureBox(
      {super.key, this.color, required this.headerText, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15)
                .copyWith(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    headerText,
                    style: GoogleFonts.mooli(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    desc,
                    style: GoogleFonts.mooli(
                        textStyle: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 14,
                    )),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
