# text_manip

Text Manipulation flutter widget.

## Installation

Add 

```bash
text_manip : ^latest_version
```
to your pubspec.yaml.

## Screenshot
<img src="https://raw.githubusercontent.com/gmetekorkmaz/images/master/text-manip/text-manip.jpg">

## Usage
### Basic
```bash
TextManip(
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
        "<b><i><u>Bold, italic and underline</u></i></b>"
);
```

### Custom Tag
Adding custom tag
```bash
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
```

### Clear All Tags
```bash
TextManip.clearTags();
```