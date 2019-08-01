import 'package:flutter/material.dart';
import 'package:text_manip/text_manip.dart';

void main() {
  // adding custom tag
  TextManip.addTags([
    // lineThrough
    TextManipTag(
      regExp: RegExp(r"<lineThrough>(.*?)</lineThrough>"),
      callback: (RegExpMatch regExpMatch) {
        return TextManipText(
          style: TextStyle(
            decoration: TextDecoration.lineThrough
          ),
          text: regExpMatch.group(1).toString()
        );
      }
    ),
    // smile
    TextManipTag(
      regExp: RegExp(r"\[smile\](.*?)\[/smile\]"),
      callback: (RegExpMatch regExpMatch) {
        return TextManipText(
          text: "🤣 " + regExpMatch.group(1).toString() + " 🤣"
        );
      }
    )

  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: SafeArea(
        child: _home(),
      )
    );
  }

  Widget _home() {
    return Center(
      child: TextManip(
        style: TextStyle(
          fontSize: 16
        ),
        text: 
          "No tag \n"
          "<b>bold</b> \n"
          "<i>italic</i> \n"
          "<u>underline</u> \n"
          "<color color='0xffff0000'>red</color> \n"
          "<fontSize size='20'>Font Size 20</fontSize> \n"
          "<backgroundColor color='0xff0000ff'>Blue Background</backgroundColor> \n"
          "<b><i><u>Bold, italic and underline</u></i></b> \n"
          "\n\nCustom \n"
          "<lineThrough>Hello</lineThrough> \n"
          "[smile]lol[/smile]"
      )
    );
  }

}