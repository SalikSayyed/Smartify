// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'dart:async' show Future;
// import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:epub/epub.dart' as Epb;
// import 'dart:ui';
// import 'package:jsonml/html2jsonml.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart';
// import 'package:html/parser.dart';
// import 'package:html/dom.dart';
import 'package:xml/xml.dart' as XM;
import 'package:xml2json/xml2json.dart' as XJ;
import 'magicwand.dart';

class EbookDetailsCopy {
  var author;
  var content;
  var authorList;
  var chapters;
  var coverImage;
  var schema;
  var title;
  EbookDetailsCopy(
      {this.author,
      this.content,
      this.authorList,
      this.chapters,
      this.coverImage,
      this.schema,
      this.title});
}

var filebytes;
void fileselectt() async {
  FilePickerResult f = await FilePicker.platform.pickFiles();
  if (f != null) {
    PlatformFile file = f.files.first;
    var filename = file.path;
    filebytes = file.bytes.toList();
    List<int> bytes = filebytes;

// Opens a book and reads all of its content into memory
    Epb.EpubBook epubBook = await Epb.EpubReader.readBook(bytes);

// COMMON PROPERTIES

// Book's title
    String title = epubBook.Title;
    print("TITLE : " + title);

// Book's authors (comma separated list)
    String author = epubBook.Author;
    print("\nAUTHOR : " + author);

// Book's authors (list of authors names)
    List<String> authors = epubBook.AuthorList;
    authors.forEach((String athr) {
      print("\t" + athr);
    });

// Book's cover image (null if there is no cover)
    Epb.Image coverImage = epubBook.CoverImage;

// CHAPTERS

// Enumerating chapters
    int i = -1;
    epubBook.Chapters.forEach((Epb.EpubChapter chapter) {
      i++;
      if (false) {
        print("Escaped!");
      } else {
        // Title of chapter
        String chapterTitle = chapter.Title;
        print("\nCHAPTER TITLE : " + chapterTitle);
        /*
  void main()=> runApp(main);
  main(){
    return MaterialApp(
      material app string arguments void main still not working and so do we not care about the work
      home: MaterialApp(
        children:[
          Widget tree and so did we not care about the working 
          and so do we not care 

          BuildApp(
            child:
              BuildContext context(
                contex
                color: Colors.green;
                working down the matter

                OIIOUOUIOIUONLaASDFASASFASSFASDFAWERQWErsdd
                dfasdlffw2roiweroihweoruihdflasddfi034082399923092340234
                sdfasdkfasdfkkfiaerower023492394924kdfaksdfkdffhl3rweerrwer
              )
          )
        ]
      )
    )
  }
   */
        // HTML content of current chapter
        //fString chapterHtmlContent = chapter.HtmlContent;
        // var jsonmle = encodeToJsonML(chapter.HtmlContent.toString()
        //             .replaceAll(RegExp('<[?].*[?]>'), ''));
        // print("\nCHAPTERHTMLCONTENT : " + jsonmle.toString());
        var dochtmlstring2 = MagicWand(chapter.HtmlContent.toString());
        ;
        //dochtmlstring.replaceAll(RegExp('<[?].*[?]>'), '');

        //print(dochtmlstring);
        //print('---------');
        //print(dochtmlstring2);

        // xml2json_object.parse(xml_document);
        // var json_document = xml2json_object.toParker(xml_document);
        //

        var xml_document = XM.parse(dochtmlstring2);
        //print(xml_document.toString().replaceAll(RegExp('<[?].*[?]>'), ''));
        final xml2json_object = XJ.Xml2Json();
        xml2json_object.parse(xml_document.toString());
        var jsonfinalstring = xml2json_object.toGData();
        //var jsonfinal = jsonfinalstring
        // print(jsonfinalstring);
        /* openonly for finalparsing*/
        // print("JSON str -->" + jsonfinalstring);

        var jsonfinal = jsonDecode(jsonfinalstring);
        print(jsonfinal);
        // print("\n----------------------------------------\nPrinting JSON -->" +
        //     jsonEncode(jsonfinal) +
        //     "\n----------------------------\n");
        // try{
        //   print(jonfinal["html"]["body"]["title"])
        // }
        /*
      if (i == 0) {
        try {
          print(jsonfinal.html.body.div[0].p.a.$t);
        } catch (e) {
          print(e);
        }
      } else {
        try {
          print(
              (jsonfinal["html"]["body"]["div"]["p"][2]["\$t"] ?? "it is null")
                  .toString());
        } catch (e) {
          print(e);
        }
      }
      */
        /*end for parsing*/
        // Nested chapters
        List<Epb.EpubChapter> subChapters = chapter.SubChapters;

        //print("\t" + subChapters.toString());
      }
    });

// CONTENT

// Book's content (HTML files, stlylesheets, images, fonts, etc.)
    Epb.EpubContent bookContent = epubBook.Content;

// IMAGES

// All images in the book (file name is the key)
    Map<String, Epb.EpubByteContentFile> images = bookContent.Images;

    Epb.EpubByteContentFile firstImage = images.values.first;

// Content type (e.g. EpubContentType.IMAGE_JPEG, EpubContentType.IMAGE_PNG)
    Epb.EpubContentType contentType = firstImage.ContentType;

// MIME type (e.g. "image/jpeg", "image/png")
    String mimeContentType = firstImage.ContentMimeType;

// HTML & CSS

// All XHTML files in the book (file name is the key)
    Map<String, Epb.EpubTextContentFile> htmlFiles = bookContent.Html;

// All CSS files in the book (file name is the key)
    Map<String, Epb.EpubTextContentFile> cssFiles = bookContent.Css;

// Entire HTML content of the book
    htmlFiles.values.forEach((Epb.EpubTextContentFile htmlFile) {
      String htmlContent = htmlFile.Content;
      // print("\nHTML CONTENT : " + htmlContent);
    });

// All CSS content in the book
    cssFiles.values.forEach((Epb.EpubTextContentFile cssFile) {
      String cssContent = cssFile.Content;
      //print("\ncssContent" + cssContent);
    });

    Map<String, Epb.EpubByteContentFile> fonts = bookContent.Fonts;

    Map<String, Epb.EpubContentFile> allFiles = bookContent.AllFiles;

    Epb.EpubPackage package = epubBook.Schema.Package;
  } else {
    print("Nothing Selected!");
  }
}
