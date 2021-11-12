import 'dart:html';

import 'package:chatisdisabled/chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (fb.apps.length == 0) {
    fb.initializeApp(
        apiKey: "AIzaSyBBNzTJ_62ZLogaDhTE69pjWaXMQPjnp6w",
        authDomain: "chatisdisabled.firebaseapp.com",
        projectId: "chatisdisabled",
        storageBucket: "chatisdisabled.appspot.com",
        messagingSenderId: "1020855228259",
        appId: "1:1020855228259:web:97fda66248272b6bbae556",
        measurementId: "G-7VWJS08RJZ");

  } else {
    fb.app();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ChatisDisabled'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String link = '';
  @override
  // TODO: implement widget
 void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      validator: (input){
                        // print("validators");
                        if (input == null || input.isEmpty) {
                          return 'Please enter a link';
                        }
                        bool youtube = RegExp(r"http(?:s?):\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-\_]*)(&(amp;)?‌​[\w\?‌​=]*)?").hasMatch(input.toString());
                        bool twitch = RegExp(r"^(?:https?:\/\/)?(?:www\.|go\.)?twitch\.tv\/([a-z0-9_]+)($|\?)").hasMatch(input.toString());
                        if(!(youtube||twitch)){
                          return "not a valid link";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        link = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter Twitch/Youtube Live Stream Link',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // print("starting");
                          if (_formKey.currentState!.validate()) {
                            print("valid");
                            CollectionReference col = FirebaseFirestore.instance.collection('rooms');
                            print('collected');
                            col.where("host_link", isEqualTo: link).get().then((doc) async {
                              print("listed");
                              if(doc.docs.isEmpty){
                              print("empty");
                              await FirebaseFirestore.instance.collection('rooms').add(
                                  {
                                    "host_link": link,
                                  }

                              ).then((value) => value.collection("messsages").add({
                                "msg" : "Hi! Welcome to the chatisdisabled for " + link + "! Please feel free to use this site as a replacement for live chat. Share the URL to share the chat.",
                                "time" : Timestamp.fromDate(DateTime(2021,  11,  10))

                              }));
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(id: doc.docs.first.id )),);
                              print("pressed and loaded");
                            }
                            else{
                              print("not empty");
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(id: doc.docs.first.id )),);
                            }
                            });

                          }

                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );

  }
}
