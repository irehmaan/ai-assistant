import 'package:aiassistant/home/presentation/home.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoToHome extends StatelessWidget {
  const GoToHome({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController getName = TextEditingController();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "What should we call you!",
              style: GoogleFonts.caveat(
                  textStyle: const TextStyle(fontSize: 30),
                  color: Colors.black),
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width / 1.6,
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15)),
                            fillColor: Colors.transparent,
                            filled: true,
                            hintText: "username",
                            hintStyle: TextStyle(color: Colors.grey.shade500)),
                        controller: getName,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(
                                        username: getName.text,
                                      )));
                        },
                        child: const Icon(Icons.arrow_forward_ios)),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
