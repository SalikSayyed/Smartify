import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:epub/epub.dart' as Epb;
import 'package:file_picker/file_picker.dart';
import 'package:xml/xml.dart' as XM;
import 'package:xml2json/xml2json.dart' as XJ;
import 'magicwand.dart';
//import 'magicwand2.dart' as mj;
import 'dart:math'; //temporary for generating random integeres

List<int> list = [0, 1, 2, 3, 4, 5];
int Chapters_Sentiment(String chapter_string) {
  final random = Random();
  int i = random.nextInt(list.length);
  return list[i];
}

class Chapters_Book {
  var chapter_title;
  var chapter_json;
  var sub_chapters;
  Chapters_Book({this.chapter_title, this.chapter_json, this.sub_chapters});
}

Future<Chapters_Book> Chapter_Parser(var epubBook, bool showhighlight) async {
  print("🙄 I am Inside!");
  int i = -1;
  Chapters_Book result = null;
  // return Future.value(Chapters_Book(
  //     chapter_json: "<html><body>Something is nothing</body></html>",
  //     chapter_title: "Something is here",
  //     sub_chapters: "No problem"));
  Epb.EpubChapter chapter = epubBook;

  if (false) {
    print("Escaped!");
  } else {
    i++;
    var a = chapter.Title;
    print("Inside here as well 😁");
    String dochtmlstring2;
    if (showhighlight) {
      dochtmlstring2 = await MagicWand(chapter.HtmlContent.toString());
    } else {
      dochtmlstring2 = chapter.HtmlContent.toString();
    }

    print("PASSED ABOVE 🤗");
    //print("🥱-->" + dochtmlstring2);
    //var dchtml = mj.A(passedString: chapter.HtmlContent.toString());
    // var dchtml = mj.A.MagicWand(chapter.HtmlContent.toString());
    // dochtmlstring2 = dchtml.lsb;
    //---------------------------------------
    // var xml_document = XM.parse(dochtmlstring2);
    // final xml2json_object = XJ.Xml2Json();
    // xml2json_object.parse(xml_document.toString());
    // var jsonfinalstring = xml2json_object.toGData();
    // var jsonfinal = jsonDecode(jsonfinalstring);
    //print(jsonfinal);
    //----------------------------------------
    var b = dochtmlstring2;
    List<Epb.EpubChapter> subChapters = chapter.SubChapters;
    var c = subChapters;
    result = Chapters_Book(chapter_title: a, chapter_json: b, sub_chapters: c);

    //print(a.toString() + b + c.toString());
  }
  bool b;
  if (result != null) {
    b = true;
  } else {
    b = false;
  }
  //print("CHECK : $b $i");

  //print(result.chapter_json.toString());
  return Future.value(result);
}
