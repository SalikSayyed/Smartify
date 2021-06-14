import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'page2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'page3.dart';
var _previousstate = "#";
class Page1 extends StatefulWidget{
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  var _currentindex = 1;
  Color _colorB = Colors.red;
  Widget _widgetvar = Container();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: RaisedButton(child: Icon(Icons.comment),onPressed: (){

          }
          ),

        title: Text("Write your commands!")
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _colorB,
        currentIndex: _currentindex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.play_arrow,color: Colors.white,size: 20,),backgroundColor: Colors.yellow,title: Text("First",style:TextStyle(fontSize: 20,color: Colors.white),)),
          BottomNavigationBarItem(icon: Icon(Icons.history,color: Colors.white,size: 20,),backgroundColor: Colors.grey,title: Text("History",style:TextStyle(fontSize: 20,color:Colors.white)),),
          BottomNavigationBarItem(icon: Icon(Icons.stop,color: Colors.white,size: 20),backgroundColor: Colors.blue,title: Text("First",style: TextStyle(fontSize: 20,color: Colors.white)),),

        ],
        onTap: (index){
          setState(() {
               _currentindex = index;
               switch (index) {
              case 0:
                _colorB = Colors.deepOrangeAccent;
                _widgetvar = FirstPage();
                break;
              case 1:
                _colorB = Colors.green;
                _widgetvar = SecondPage();
                break;
              case 2:
                _colorB = Colors.blue;
                _widgetvar = ThirdPage();
                break;
            }
          });
        },
      ),
     body: _widgetvar,
    );
    //bottomNavigationBar:
  }



}
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  var host = _previousstate;
  Color clr = Colors.blue;
  var _hostname = _previousstate;
  var lochost;
  var _response;
  var a = "null";
  var _command = "time";
  @override
  Widget build(BuildContext context) {

    String appresponse() {
      if (_response == null) {
        return "Null";
      }
      else {
        return _response.body;
      }
    }

      void cmdpress() async{
        try{

          print(_hostname+"="+_command);
          var temp = await http.get(_hostname+"="+_command,);
          setState(() {
            _hostname = host;
            _response = temp;
            a = appresponse();
            clr = Colors.green;
            /*
            var fsconnect = FirebaseFirestore.instance;
            fsconnect.collection("commands").add({
              'cmd': _command,
              'time': DateTime.now(),
              'cmdoutput': temp.body,
            }); */
          });



         // print(DateTime.now().toString());
        }
        catch (e) {
          _command ="null";
          print(e);
          setState(() {
            clr = Colors.grey;
          });

        }
      }

      return Center(
        child: Container(
          color: Colors.grey.shade100,
          width: 500,
          height: 700,
          child: Column(
            children: <Widget>[RaisedButton(color: clr,child: Column(children:<Widget>[Icon(Icons.computer,color: Colors.black,),Text("Set Host",textAlign: TextAlign.center,)]),onPressed: (){
          return showDialog(
              context:context,builder: (context){
            return AlertDialog(
              title: Text("Set Script Address with Hostname (Ex. http://12.3.3.3/any.py?var)"),
              content: Container(
                height: 150,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color:Colors.blue),
                ),
                      child: TextField(
                          onChanged: (String str){
                            lochost = str;
                          }
                      ),
                    ),
                    RaisedButton(
                      child: Text("Set Host"),
                      onPressed: (){
                        setState(() {

                          host = lochost;
                          _hostname=host;

                          _previousstate=_hostname;

                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          );
        },),
              TextField(
                  cursorColor: Colors.black,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "Arial",fontSize: 20,),
                  decoration: InputDecoration(
                    labelText: 'CMD',
                    hintText: 'Commands',
                    icon: Icon(Icons.computer,size: 40,),
                    hintStyle: TextStyle(fontFamily: "Arial",fontSize: 20,),
                  ),
                  onChanged: (value) {
                    _command = value;
                  }
              ),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                child: Icon(
                  Icons.directions_run,
                  color: Colors.red,
                ),
                splashColor: Colors.red,
                //onPressed: (){print("pressed!");},
                onPressed: cmdpress,
              ),
              SizedBox(height : 10,),
              Container(
                height: 350,
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: SingleChildScrollView(child: Column(children: <Widget>[Text("Response : "),Text(a,style: TextStyle(fontFamily: "Arial",color: Colors.white,fontSize: 20,),)])),
              )
            ],
          ),
        ),
      );
    }


}
