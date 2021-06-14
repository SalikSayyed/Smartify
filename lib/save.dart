import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/src/widgets/image.dart' as Img;
import 'package:loading_indicator/loading_indicator.dart' as ldr;
//import 'package:flutter/services.dart';
import 'package:epub/epub.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart'
    as scp;
import 'dictionary.dart' as d;
//import 'package:jsonml/html2jsonml.dart';
import 'test_epub_book_plugin.dart';
import 'test_book_plugin.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart'
    as HtmlCore;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
bool playaudio = true;

// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart'
//     as HtmlBase;
// import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/html_parser.dart';

// import 'package:jsonml/html5lib2jsonml.dart';
// import 'package:jsonml/jsonml2dom.dart';
// import 'package:jsonml/jsonml2html5lib.dart';

void toggleAudio(bool value) {
  if (playaudio == true) {
    playaudio = false;
  } else {
    playaudio = true;
  }
}

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
  var chaptersl;
  var coverImage;
  var schema;
  var title;
  EbookDetails(
      {this.author,
      this.content,
      this.authorList,
      this.chaptersl,
      this.coverImage,
      this.schema,
      this.title});
}

class _EpubDisplayState extends State<EpubDisplay> {
  var data;
  EbookDetails ebookdetails;
  var filebytes;

  Future<EbookDetails> _readEjson() async {
    var futuredata = await _readEpub();
    var author = futuredata.Author ?? "NULL";
    var content = futuredata.Content ?? "NULL";
    var authorList = futuredata.AuthorList ?? "NULL";
    var chapters = futuredata.Chapters ?? null;
    var coverImage = futuredata.CoverImage ?? null;
    var schema = futuredata.Schema ?? null;
    var title = futuredata.Title ?? null;
    return EbookDetails(
        author: author,
        content: content,
        authorList: authorList,
        chaptersl: chapters,
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

      return Future.value(rawdat);
    } catch (e) {
      //print(e);
      return Future.value(null);
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
    int _savedIndex;
    @override
    void dispose() {
      audioPlayer.stop();
    }

    return Container(
        child: Expanded(
      child: SizedBox(
        height: 200.0,
        child: FutureBuilder(
          future: _readEjson(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            final scp.ItemScrollController _itemScrollController =
                scp.ItemScrollController();
            //_printdata();
            //_readEpub();
            var str = null;

            if (snapshot.data == snapshot.error) {
              return Text("ERROR..");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: ldr.LoadingIndicator(
                  indicatorType: ldr.Indicator.ballZigZag,
                  color: Colors.pink.shade200,
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return Text(
                  "Nothing to Show..",
                  style: TextStyle(color: Colors.redAccent),
                );
              } else {
                //print(snapshot.data.chaptersl.toString());
                //List<Chapters_Book> chaptertitless = snapshot.data.chaptersl;
                //print(
                //"PRINTING TOTAL LENGTH ---> ${snapshot.data.chaptersl.length}");
                //AutoScrollController controller;
                double i = 0;
                _savedIndex = snapshot.data.chaptersl.length;

                return Column(
                  children: [
                    SafeArea(
                      child: Column(
                        children: [
                          Text(
                            snapshot.data.title ?? "NULL",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            snapshot.data.author ?? "NULL",
                            style: TextStyle(fontSize: 20),
                          ),
                          
                          Divider(
                            color: Colors.pink,
                            thickness: 2.0,
                          ),

                          //Text(snapshot.data.)
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.brown.shade100,
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      child: Stack(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.75,
                              width: MediaQuery.of(context).size.width * 0.98,
                              child: Scrollbar(
                                showTrackOnHover: true,
                                isAlwaysShown: true,
                                child: scp.ScrollablePositionedList.builder(
                                    itemScrollController: _itemScrollController,
                                    itemCount: snapshot.data.chaptersl.length,
                                    // itemScrollController: itemScrollController,
                                    // itemPositionsListener:
                                    //     itemPositionsListener,
                                    scrollDirection: Axis.horizontal,
                                    physics: PageScrollPhysics(),
                                    itemBuilder: (context, int index) {
                                      
                                      //print(snapshot.data.title ?? "Title not there");
                                      //print(snapshot.data ?? "Well Not working");
                                      return FutureBuilder(
                                        future: Chapter_Parser(
                                            snapshot.data.chaptersl[index],
                                            showhighlight),
                                        builder: (BuildContext ctx,
                                            AsyncSnapshot snp) {
                                          if (snp.connectionState ==
                                              ConnectionState.done) {
                                            if (snp.data == null) {
                                              return Text("Nothing Here! 😪");
                                            }
                                            var chapter_item = null;
                                            try {
                                              chapter_item = snp.data;
                                              print("I tried 😏");
                                            } catch (e) {
                                              print(e);
                                            }
                                            bool chapter_title_bool = true;
                                            var chapter_title_saved;
                                            var chapter_json_saved;
                                            try {
                                              chapter_title_saved =
                                                  chapter_item.chapter_title ??
                                                      "NULL";
                                            } catch (e) {
                                              chapter_title_bool = false;
                                              print(e);
                                            }
                                            try {
                                              chapter_json_saved =
                                                  chapter_item.chapter_json ??
                                                      "NULL";
                                            } catch (e) {
                                              chapter_json_saved =
                                                  "<html><b>Nothing here</b></html>";
                                              print(e);
                                            }
                                            return Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.brown.shade100,
                                                  border: Border.all(
                                                      color: Colors.blueAccent,
                                                      width: 1.0)),
                                              child: Column(children: [
                                                Container(
                                                  child: Text(
                                                    //"Hello! Nothing is being called",

                                                    chapter_title_bool
                                                        ? chapter_title_saved
                                                        : "---Not Specified--",
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                ),
                                                Divider(
                                                  color: Colors.blueAccent,
                                                  thickness: 1.5,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.65,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.98,
                                                  child: Scrollbar(
                                                    child: ListView.builder(
                                                      itemCount: 1,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemBuilder:
                                                          (BuildContext ctx,
                                                              int idx) {
                                                        return HtmlCore
                                                            .HtmlWidget(
                                                          chapter_json_saved,
                                                          textStyle: TextStyle(
                                                            fontSize: 20,
                                                          ),
                                                          customStylesBuilder:
                                                              (element) {
                                                            if (element
                                                                .localName
                                                                .contains(
                                                                    'span')) {
                                                              return {
                                                                'color': 'red'
                                                              };
                                                              //   return StatefulBuilder(builder:
                                                              //       (BuildContext
                                                              //               ctxx,
                                                              //           StateSetter
                                                              //               setState) {
                                                              //     Color ClrEnd = Colors
                                                              //         .orange
                                                              //         .withOpacity(
                                                              //             0.5);
                                                              //     return TweenAnimationBuilder<
                                                              //         Color>(
                                                              //       tween: ColorTween(
                                                              //           begin: (ClrEnd ==
                                                              //                   Colors.red.withOpacity(
                                                              //                       0.5))
                                                              //               ? Colors.orange.withOpacity(
                                                              //                   0.5)
                                                              //               : Colors
                                                              //                   .red
                                                              //                   .withOpacity(0.5),
                                                              //           end: ClrEnd),
                                                              //       curve: Curves
                                                              //           .fastLinearToSlowEaseIn,
                                                              //       duration:
                                                              //           Duration(
                                                              //               seconds:
                                                              //                   4),
                                                              //       builder: (BuildContext
                                                              //               ctx,
                                                              //           Color
                                                              //               varcolor,
                                                              //           Widget
                                                              //               child) {
                                                              //         return Text(
                                                              //           element
                                                              //               .innerHtml,
                                                              //           style: TextStyle(
                                                              //               backgroundColor:
                                                              //                   varcolor,
                                                              //               fontSize:
                                                              //                   20.0),
                                                              //         );
                                                              //       },
                                                              //       onEnd: () {
                                                              //         setState(
                                                              //             () {
                                                              //           (ClrEnd == Colors.red.withOpacity(0.5))
                                                              //               ? ClrEnd = Colors.blue.withOpacity(
                                                              //                   0.5)
                                                              //               : ClrEnd = Colors
                                                              //                   .red
                                                              //                   .withOpacity(0.5);
                                                              //         });
                                                              //       },
                                                              //     );
                                                              //   });
                                                              //
                                                            }
                                                            return null;
                                                          },
                                                        );
                                                        // return Text(
                                                        //   chapter_item.chapter_json
                                                        //           .toString() ??
                                                        //       "NULL",
                                                        //   //.chapter_json
                                                        //   // .toString(),
                                                        //   style: TextStyle(
                                                        //     fontSize: 18.0,
                                                        //   ),
                                                        // );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            );
                                          } else {
                                            return ldr.LoadingIndicator(
                                              indicatorType:
                                                  ldr.Indicator.ballGridBeat,
                                              color: Colors.pink,
                                            );
                                          }
                                        },
                                      );
                                    }),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 30,
                            left: MediaQuery.of(context).size.width * 0.8,
                            child: Container(
                              width: 150,
                              height: 60,
                              color: Colors.blue.shade200,
                              child: TextField(
                                onSubmitted: (value) {
                                  return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            value,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 25.0),
                                          ),
                                          content:
                                              d.DictioneryResult(str: value),
                                        );
                                      });
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  fillColor: Colors.blueAccent.shade200,
                                  hoverColor: Colors.green.shade200,
                                  labelText: 'Dictionary',
                                  hintText: 'Search for Any Word',
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            left: 5,
                            child: StatefulBuilder(
                              builder: (BuildContext ctxxx, StateSetter sss) {
                                List<String> urilistImage = [
                                  "images/joy.gif",
                                  "images/angry.gif",
                                  "images/fear.jpg",
                                  "images/sad.gif",
                                  "images/neutral.gif"
                                ];
                                return Slider(
                                    divisions: _savedIndex - 1,
                                    activeColor: Colors.amber,
                                    inactiveColor: Colors.blue.shade300,
                                    min: 0,
                                    max: _savedIndex.toDouble() - 1,
                                    value: i,
                                    label: "Page : ${i + 1}",
                                    onChanged: (value) {
                                      _itemScrollController.scrollTo(
                                          index: value.toInt(),
                                          duration: Duration(milliseconds: 50));

                                      sss(() {
                                        i = value;
                                      });
                                      if (playaudio) {
                                        try {
                                          int cntrl;
                                          play() async {
                                            String url =
                                                "https://files.freemusicarchive.org/storage-freemusicarchive-org/tracks/6k4EIyTykJVDVjv5mqf5OL8HLwL8Mu6Ic0uyS3yB.mp3";
                                            int result = await audioPlayer
                                                .play(url, isLocal: false);
                                            print("current index --> $i");

                                            if (result == 1) {
                                              cntrl = 1;
                                              print("Playing!");
                                              // success
                                            }
                                          }

                                          st() async {
                                            int res = await audioPlayer.stop();
                                            if (res == 1) {
                                              print("Stopped!");
                                              cntrl = 0;
                                            }
                                          }

                                          if (cntrl == 1) {
                                            st();
                                          } else {
                                            play();
                                          }

                                          print("someurl");
                                          return showDialog(
                                              context: ctxxx,
                                              barrierDismissible: false,
                                              builder: (BuildContext ctxxx) {
                                                Future.delayed(
                                                    Duration(seconds: 1), () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                });
                                                return SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    content: Img.Image.asset(
                                                        urilistImage[
                                                            i.toInt() % 6]),
                                                  ),
                                                );
                                              });
                                        } catch (e) {
                                          print(e);
                                        }
                                      }
                                    });
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 5,
                            child: StatefulBuilder(
                                builder: (BuildContext ctx, StateSetter st) {
                              return Switch(
                                onChanged: (bool value) {
                                  print(playaudio);
                                  st(() {
                                    playaudio = value;
                                    stt() async {
                                      int res = await audioPlayer.stop();
                                      if (res == 1) {
                                        print("Stopped!");
                                      }
                                    }

                                    stt();
                                  });
                                },
                                value: playaudio,
                                activeColor: Colors.blue,
                                activeTrackColor: Colors.yellow,
                                inactiveThumbColor: Colors.redAccent,
                                inactiveTrackColor: Colors.orange,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            } else {
              return Container(
                child: Text("NULL"),
              );
            }
          },
        ),
      ),
    ));
  }
}

