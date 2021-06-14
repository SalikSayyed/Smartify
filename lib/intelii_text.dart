import 'package:flutter/material.dart';

class IntelliText extends StatefulWidget {
  String data;
  List<Color> list_data;
  IntelliText({
    this.data,
    this.list_data,
  });
  @override
  _IntelliTextState createState() => _IntelliTextState();
}

class _IntelliTextState extends State<IntelliText> {
  String data = "";
  List<Color> list_data = [
    Colors.transparent,
    Colors.transparent,
    Colors.transparent,
    Colors.transparent
  ];
  @override
  Widget build(BuildContext context) {
    double opc = 0;
    setState(() {
      data = widget.data;
      list_data = widget.list_data;
      opc = 1;
    });

    List<String> str = data.split('<str>');
    int len = str.length;
    int i = 0;
    var a;
    TextSpan _textspan(List<String> strr, double opac) {
      if (len > 0) {
        String s = strr.elementAt(0);
        print(s);
        len--;
        if (s.startsWith('<k>')) {
          i = 0;
          a = s.replaceAll(RegExp(r'<k>'), '');
        } else {
          if (s.startsWith('<v>')) {
            i = 1;
            a = s.replaceAll(RegExp(r'<v>'), '');
          } else {
            if (s.startsWith('<r>')) {
              i = 2;
              a = s.replaceAll(RegExp(r'<r>'), '');
            } else {
              i = 3;
            }
          }
        }
        print("i :: $i");

        //s.startsWith('<k>') ? s.replaceAll('<k>','') : s.startsWith('<r>') ? s.replaceAll('<r>','') : s.startsWith('<v>') ? s.replaceAll('<v>','') : print("do_nothing") ;
        strr.removeAt(0);
        return TextSpan(
          text: s.startsWith('<k>')
              ? s.replaceAll('<k>', '')
              : s.startsWith('<r>')
                  ? s.replaceAll('<r>', '')
                  : s.startsWith('<v>')
                      ? s.replaceAll('<v>', '')
                      : s.replaceAll(r'', ''),
          //text : "Something to Worry",
          style: TextStyle(
            color: Colors.black,
            backgroundColor: list_data.elementAt(i),
          ),
          children: [_textspan(strr, opac)],
        );
      } else {
        return TextSpan(
          text: " ",
        );
      }
    }

    return Container(
      child: SelectableText.rich(
        TextSpan(
          children: [
            _textspan(str, 1),
          ],
        ),
      ),
    );
  }
}
