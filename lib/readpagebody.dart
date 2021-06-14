import 'package:flutter/material.dart';
import './epubreader.dart';

class ReadPageBody extends StatefulWidget {
  String filename;
  List<int> bytes;
  ReadPageBody({this.filename, this.bytes});
  @override
  _ReadPageBodyState createState() => _ReadPageBodyState();
}

class _ReadPageBodyState extends State<ReadPageBody> {
  String filename = "default.epub";
  List<int> filebytes;
  //String filepath = "jsons/sample.epub";
  @override
  Widget build(BuildContext context) {
    setState(() {
      filename = widget.filename ?? "default.epub";
      filebytes = widget.bytes;
    });
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Container(
                height: 30.0,
                width: 200.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.redAccent),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Text(
                  filename,
                  style: TextStyle(fontSize: 20.0, color: Colors.black),
                )),
          ),
          EpubDisplay(bytes: filebytes),
        ],
      ),
    );
  }
}
