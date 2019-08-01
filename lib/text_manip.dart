library text_manip;

import 'package:flutter/widgets.dart';

class TextManipText {
  final TextStyle style;
  final String text;

  TextManipText({
    this.style,
    this.text
  });

}

class TextManipTag {

  final RegExp regExp;
  final TextManipText Function(RegExpMatch) callback;

  TextManipTag({
    this.regExp,
    this.callback
  });

}

class TextManip extends StatelessWidget {

  static final List<TextManipTag> _tags = [
    // bold
    TextManipTag(
      regExp: RegExp(r"<b>(.*?)</b>"),
      callback: (RegExpMatch regExpMatch) {
        return TextManipText(
          style: TextStyle(fontWeight: FontWeight.bold),
          text: regExpMatch.group(1).toString()
        );
      }
    ),
    // italic
    TextManipTag(
      regExp: RegExp(r"<i>(.*?)</i>"),
      callback: (RegExpMatch regExpMatch) {
        return TextManipText(
          style: TextStyle(fontStyle: FontStyle.italic),
          text: regExpMatch.group(1).toString()
        );
      }
    ),
    // underline
    TextManipTag(
      regExp: RegExp(r"<u>(.*?)</u>"),
      callback: (RegExpMatch regExpMatch) {
        return TextManipText(
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
          text: regExpMatch.group(1).toString()
        );
      }
    ),
    // fontSize
    TextManipTag(
      regExp: RegExp(r"<fontSize size='(.*?)'>(.*?)</fontSize>"),
      callback: (RegExpMatch regExpMatch) {
        return TextManipText(
          style: TextStyle(fontSize: double.parse(regExpMatch.group(1))),
          text: regExpMatch.group(2).toString()
        );
      }
    ),
    // backgroundColor
    TextManipTag(
      regExp: RegExp(r"<backgroundColor color='(.*?)'>(.*?)</backgroundColor>"),
      callback: (RegExpMatch regExpMatch) {
        return TextManipText(
          style: TextStyle(backgroundColor: Color(int.parse(regExpMatch.group(1)))),
          text: regExpMatch.group(2)
        );
      }
    ),
    // color
    TextManipTag(
      regExp: RegExp(r"<color color='(.*?)'>(.*?)</color>"),
      callback: (RegExpMatch regExpMatch) {
        return TextManipText(
          style: TextStyle(color: Color(int.parse(regExpMatch.group(1)))),
          text: regExpMatch.group(2)
        );
      }
    )
  ];

  static void clearTags() {
    _tags.clear();
  }

  static void addTags(List<TextManipTag> tags) {
    _tags.addAll(tags);
  }

  final String text;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final Locale locale;
  final StrutStyle strutStyle;

  final TextStyle style;
  final TextWidthBasis textWidthBasis;

  const TextManip({
    Key key,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.textScaleFactor = 1.0,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.style,
    this.text
  }) : assert(textAlign != null),
       assert(softWrap != null),
       assert(overflow != null),
       assert(textScaleFactor != null),
       assert(maxLines == null || maxLines > 0),
       assert(textWidthBasis != null),
       assert(text != null),
       super(key: key);

  TextSpan _scan(TextManipText textManipText) {
    
    List<TextSpan> children = [];
    String currentText = textManipText.text;

    List<Map<String, dynamic>> matches = [];

    // scan all tags
    _tags.forEach((TextManipTag tag) {
      matches.addAll(
        tag.regExp.allMatches(currentText).map((RegExpMatch regExpMatch) => {
          "tag": tag,
          "regExpMatch": regExpMatch
        })
      );
    });

    if (matches.isNotEmpty) {
      // sort result
      matches.sort((Map<String, dynamic> a, Map<String, dynamic> b) => (a["regExpMatch"] as RegExpMatch).start.compareTo((b["regExpMatch"] as RegExpMatch).start));

      int beforeEnd = 0;
      matches.forEach((Map<String, dynamic> match) {
        final RegExpMatch regExpMatch = match["regExpMatch"] as RegExpMatch;
        final TextManipTag textManipTag = match["tag"] as TextManipTag;

        // without deep
        if (beforeEnd > regExpMatch.start)
          return;

        if (beforeEnd != regExpMatch.start)
          children.add(TextSpan(
            text: currentText.substring(beforeEnd, regExpMatch.start),
            style: textManipText.style
          ));

        children.add(
          _scan((textManipTag).callback(regExpMatch))
        );

        beforeEnd = regExpMatch.end;
      });

      if (beforeEnd != currentText.length)
        children.add(TextSpan(
          text: currentText.substring(beforeEnd),
          style: textManipText.style
        ));

    }

    return TextSpan(
      text: children.isEmpty ? currentText : "",
      children: children,
      style: textManipText.style
    );

  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      key: key,
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: TextWidthBasis.parent,
      text: _scan(TextManipText(
        style: style,
        text: text
      ))
    );
  }

}