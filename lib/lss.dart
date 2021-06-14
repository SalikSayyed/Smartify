import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  var a = diFuture('hello');
  a.then((value) {
    pretty_printer(value);
  });
}


void pretty_printer(DictClass s) {
  print(s.word);
  s.phonetics.forEach((element) {
    print("Spoken like : ${element.text}");
    print("Can Be found at : ${element.audio}");
   
  });
  s.meanings.forEach((element) {
    print("Parts of Speech : ${element.partOfSpeech}");
    element.definitions.forEach((ele) {
      print("Def --> ${ele.definition}");
      print("Exa --> ${ele.example}");
    });
  });
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
