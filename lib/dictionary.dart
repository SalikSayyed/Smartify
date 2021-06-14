import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

/*
Delete if not working audio files are here
Single Audio Player Object for dictionary
*/
/*
final cache = AudioCache();
final ply = AudioPlayer();
int checker = 0;
AudioPlayer player;
Tst(String alert) {
  print(alert);
}

void _playFile(String musicname) async {
  if (checker == 0) {
    player = await cache.play(musicname);
    player = await cache.play('stevejobs.mp3');
    checker = 1;
  } else {
    _stopFile();
    checker = 0;
  }
  Tst("Audio playing");
  checker = 1; // assign player here
}

void _pauseFile() async {
  if (checker == 1) {
    player?.pause();
  }
  player?.pause();
  Tst("Audio paused");
  checker = 0; // assign player here
}

void _resumeFile() async {
  if (checker == 0) {
    player?.resume();
  }
  checker = 1;
  Tst("Audio resumed!");
}

void _stopFile() {
  if (checker == 1) {
    player?.stop();
  }
  //player?.stop(); // stop the file like this
  checker = 0;
  Tst("Audio Stopped!");
}

/*
End of audio files
*/
*/

class DictioneryResult extends StatefulWidget {
  var str;
  DictioneryResult({this.str});
  @override
  _DictioneryResultState createState() => _DictioneryResultState();
}

class _DictioneryResultState extends State<DictioneryResult> {
  var str;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      str = widget.str;
    });

    return FutureBuilder(
        future: diFuture(str),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('WAITING');
          }
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occured',
                  style: TextStyle(fontSize: 18),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                physics: PageScrollPhysics(),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        //--word--
                        snapshot.data.word ?? " ",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18),
                      ),
                      Builder(builder: (BuildContext ctx) {
                        AudioPlayer audioPlayer =
                            AudioPlayer(mode: PlayerMode.LOW_LATENCY);
                        List<Widget> wid = [];
                        snapshot.data.phonetics.forEach((element) {
                          wid.add(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                //--pronounce--
                                element.text ?? " ",
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 15,
                                width: 15,
                                child: FloatingActionButton(
                                  backgroundColor: Colors.blue,
                                  hoverColor: Colors.red,
                                  onPressed: () {
                                    try {
                                      int cntrl;
                                      play() async {
                                        int result = await audioPlayer.play(
                                            element.audio.toString(),
                                            isLocal: false);

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

                                      print(element.audio);
                                    } catch (e) {
                                      print(e);
                                    }
                                    print("Pressing!");
                                  },
                                  hoverElevation: 10,
                                  // element.audio,
                                  // textAlign: TextAlign.left,
                                  child: Icon(
                                    Icons.music_note_outlined,
                                    size: 10,
                                  ),
                                ),
                              ),
                            ],
                          ));
                        });
                        return Row(
                          children: wid,
                        );
                      }),
                      Builder(builder: (BuildContext ctx) {
                        List<Widget> wid = [];
                        snapshot.data.meanings.forEach((element) {
                          wid.add(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                element.partOfSpeech ?? " ",
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.blue),
                              ),
                              Builder(
                                builder: (BuildContext ctxx) {
                                  List<Widget> wid_child = [];
                                  element.definitions.forEach((ele) {
                                    wid_child.add(Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ele.definition ?? " ",
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          ele.example ?? " ",
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ));
                                  });
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: wid_child,
                                  );
                                },
                              ),
                            ],
                          ));
                        });
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: wid,
                        );
                      }),
                    ]),
              );
            }
          }
        });
  }
}

//--------------------------CLASSES STUFF------------------------------
Future<DictClass> diFuture(var str) async {
  String word = str;
  final String host = 'api.dictionaryapi.dev';

  var url = Uri.https('$host', '/api/v2/entries/en_US/$str', {'q': '{http}'});

  // Await the http get response, then decode the json-formatted response.
  var response = await http.get(url);
  var sb = response.body.toString();
  var dict_json = json.decode(response.body);
  //return dict_json;
  Map<String, dynamic> dict_map = {
    'word': dict_json[0]['word'],
    'meanings': dict_json[0]['meanings'],
    'phonetics': dict_json[0]['phonetics'],
  };
  if (response.statusCode == 200) {
    DictClass dict_class = DictClass.fromJson(dict_map);

    return dict_class;
  } else {
    print('Request failed with status: ${response.statusCode}.');
  }
}

class DictClass {
  String word;
  List<Phonetics> phonetics;
  List<Meanings> meanings;

  DictClass({this.word, this.phonetics, this.meanings});

  DictClass.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    if (json['phonetics'] != null) {
      phonetics = new List<Phonetics>();
      json['phonetics'].forEach((v) {
        phonetics.add(new Phonetics.fromJson(v));
      });
    }
    if (json['meanings'] != null) {
      meanings = new List<Meanings>();
      json['meanings'].forEach((v) {
        meanings.add(new Meanings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    if (this.phonetics != null) {
      data['phonetics'] = this.phonetics.map((v) => v.toJson()).toList();
    }
    if (this.meanings != null) {
      data['meanings'] = this.meanings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Phonetics {
  String text;
  String audio;

  Phonetics({this.text, this.audio});

  Phonetics.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    audio = json['audio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['audio'] = this.audio;
    return data;
  }
}

class Meanings {
  String partOfSpeech;
  List<Definitions> definitions;

  Meanings({this.partOfSpeech, this.definitions});

  Meanings.fromJson(Map<String, dynamic> json) {
    partOfSpeech = json['partOfSpeech'];
    if (json['definitions'] != null) {
      definitions = new List<Definitions>();
      json['definitions'].forEach((v) {
        definitions.add(new Definitions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partOfSpeech'] = this.partOfSpeech;
    if (this.definitions != null) {
      data['definitions'] = this.definitions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Definitions {
  String definition;
  String example;

  Definitions({this.definition, this.example});

  Definitions.fromJson(Map<String, dynamic> json) {
    definition = json['definition'];
    example = json['example'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['definition'] = this.definition;
    data['example'] = this.example;
    return data;
  }
}
//-------------------------------------------STUFF ENDS HERE AND NOW ------------------------------------------------
