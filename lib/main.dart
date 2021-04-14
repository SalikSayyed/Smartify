import 'package:flutter/material.dart';
import './readpagebody.dart';
import 'package:file_picker/file_picker.dart';
import 'test_epub_book_plugin.dart';

void main() => runApp(ReadPage());

class ReadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SMARTIFY",
      home: ReadScaffold(),
    );
  }
}

class ReadScaffold extends StatefulWidget {
  ReadScaffold();
  @override
  _ReadScaffoldState createState() => _ReadScaffoldState();
}

class _ReadScaffoldState extends State<ReadScaffold> {
  String filename;
  var filebytes;
  @override
  Widget build(BuildContext context) {
    void _fileselec() async {
      FilePickerResult f = await FilePicker.platform.pickFiles();
      if (f != null) {
        PlatformFile file = f.files.first;
        setState(() {
          filename = file.path;
          filebytes = file.bytes.toList();
        });
      } else {
        print("Nothing Selected!");
      }
    }

    void _setfilename(String fln) {
      setState(() {
        filename = fln;
      });
    }

    Color starunlike = Colors.grey;
    Color starlike = Colors.yellowAccent;

    return Scaffold(
      drawer: Drawer(
        elevation: 8.0,
        child: ListView(
          children: [
            ListTile(
                leading: Icon(Icons.book),
                hoverColor: Colors.red[100],
                title: Text("Sample1.epub"),
                onTap: () => _setfilename("Sample1.epub"),
                trailing: Icon(
                  Icons.star,
                  size: 8.0,
                )),
            ListTile(
                leading: Icon(Icons.book),
                hoverColor: Colors.red[100],
                title: Text("Sample3.epub"),
                onTap: () => _setfilename("Sample3.epub"),
                trailing: Icon(
                  Icons.star,
                  size: 8.0,
                )),
            ListTile(
                leading: Icon(Icons.book),
                hoverColor: Colors.red[100],
                title: Text("Sample4.epub"),
                onTap: () => _setfilename("Sample4.epub"),
                trailing: Icon(
                  Icons.star,
                  size: 8.0,
                )),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Row(children: [
          Text("Reading mode !"),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 30.0,
              width: 30.0,
              child: FloatingActionButton(
                isExtended: false,
                backgroundColor: Colors.redAccent,
                hoverColor: Colors.yellowAccent,
                onPressed: fileselectt,
                child: Icon(
                  Icons.library_add,
                  size: 15.0,
                ),
              ),
            ),
          ),
        ]),
        titleTextStyle: TextStyle(fontSize: 20.0),
      ),
      body: ReadPageBody(filename: filename, bytes: filebytes),
    );
  }
}
