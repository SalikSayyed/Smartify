import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:epub/epub.dart';
//import 'package:jsonml/html2jsonml.dart';
import 'test_epub_book_plugin.dart';

// import 'package:jsonml/html5lib2jsonml.dart';
// import 'package:jsonml/jsonml2dom.dart';
// import 'package:jsonml/jsonml2html5lib.dart';

class EpubDisplay extends StatefulWidget {
  var bytes;
  EpubDisplay({this.bytes});
  @override
  _EpubDisplayState createState() => _EpubDisplayState();
}

class EbookDetails {
  var author;
  var content;
  var authorList;
  var chapters;
  var coverImage;
  var schema;
  var title;
  EbookDetails(
      {this.author,
      this.content,
      this.authorList,
      this.chapters,
      this.coverImage,
      this.schema,
      this.title});
}

class _EpubDisplayState extends State<EpubDisplay> {
  var data;
  EbookDetails ebookdetails;
  var filebytes;
  Future _readEjson() async {
    var futuredata = await _readEpub();
    var author = futuredata.Author;
    var content = futuredata.Content;
    var authorList = futuredata.AuthorList;
    var chapters = futuredata.Chapters;
    var coverImage = futuredata.CoverImage;
    var schema = futuredata.Schema;
    var title = futuredata.Title;
    return EbookDetails(
        author: author,
        content: content,
        authorList: authorList,
        chapters: chapters,
        coverImage: coverImage,
        schema: schema,
        title: title);
  }

  Future _readjson() async {
    var rawdata = await rootBundle.loadString("jsons/sample.json");
    data = await json.decode(rawdata);

    return data;
  }

  Future<EpubBook> _readEpub() async {
    try {
      EpubBook rawdat = await EpubReader.readBook(filebytes);
      //print(filebytes.toString());//this is working
      // print("-->Look here-->");
      // var rawdat_html = rawdat.Content.Html;
      // rawdat_html
      // print(rawdat_html);
      //fileselectt();
      
      return rawdat;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _printdata() {
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      filebytes = widget.bytes;
    });
    return Container(
        child: Expanded(
      child: SizedBox(
        height: 200.0,
        child: FutureBuilder(
          future: _readEjson(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //_printdata();
            _readEpub();
            if (snapshot.data == snapshot.error) {
              return Text("ERROR..");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                "Nothing here.. check the file..",
                style: TextStyle(color: Colors.red),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return Text(
                  "Nothing to Show..",
                  style: TextStyle(color: Colors.redAccent),
                );
              } else {
                return Scrollbar(
                  child: ListView.builder(
                      itemCount: 11,
                      itemBuilder: (BuildContext context, int index) {
                        return Text(
                          snapshot.data.title ?? " ",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        );
                      }),
                );
              }
            }
          },
        ),
      ),
    ));
  }
}
