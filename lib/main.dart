import 'dart:async';
import 'dart:html';

import 'package:buy_me_a_coffee_widget/buy_me_a_coffee_widget.dart';
import 'package:chatisdisabled/chat/chat.dart';
import 'package:chatisdisabled/tv/tv_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:youtube_parser/youtube_parser.dart';

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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  _auth.signInAnonymously();
  window.onBeforeUnload.listen((event) async{
    // do something
    FirebaseAuth.instance.currentUser!.delete();
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'ChatIsDisabled - A Chat For When You Can\'t'),
      title: 'ChatIsDisabled',
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
        primarySwatch: Colors.cyan,
        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.white),
          headline2: TextStyle(color: Colors.white),
          headline3: TextStyle(color: Colors.white),
          headline4: TextStyle(color: Colors.white),
          headline5: TextStyle(color: Colors.white),
          headline6: TextStyle(color: Colors.white),
          button: TextStyle(color: Colors.white)
        )
      ),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
    return  ResponsiveWrapper.builder(
        Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Row(
              children: [
                Text(widget.title, style: TextStyle(color: Colors.white),),
              ],
            ),

          ),
          body: Column(
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        autofocus: true,
                        onFieldSubmitted: (value) async {
                          // print("starting");
                          submit();

                        },
                        validator: (input) {
                          link = input!;
                          // print("validators");
                          if (input.isEmpty) {
                            return 'Please enter a link';
                          }
                          bool youtube = RegExp(r"http(?:s?):\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-\_]*)(&(amp;)?‌​[\w\?‌​=]*)?").hasMatch(input.toString());
                          bool twitch = RegExp(r"^(?:https?:\/\/)?(?:www\.|go\.)?twitch\.tv\/([a-z0-9_]+)($|\?)").hasMatch(input.toString());
                          if(!(youtube||twitch)){
                            return "not a valid link";
                          }
                          else if (youtube){
                            link = getIdFromUrl(link)!;
                            if(link == null){
                              return "Youtube link not valid";
                            }
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter Twitch/Youtube Live Stream Link',
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // print("starting");
                        submit();

                      },
                      child: const Text('Chat!', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              // Text("OR",style: TextStyle(fontSize: 25)),
              // Text("Choose A Show", style: TextStyle(fontSize: 20),),
              // Container(height: 100,
              // child: TvGrid(),),

            ],
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ),
      defaultScale: true,
      minWidth: 480,
      breakpoints: [
        ResponsiveBreakpoint.autoScale(480, name: MOBILE),
        ResponsiveBreakpoint.autoScale(800, name: TABLET),
        ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
        ResponsiveBreakpoint.autoScale(2460, name: '4K'),
      ],
    );

  }
  void submit(){
    if (_formKey.currentState!.validate()) {
      print("valid");
      CollectionReference col = FirebaseFirestore.instance.collection('rooms');
      print('collected');
      col.where("host_link", isEqualTo: link).get().then((doc) async {
        print("listed");
        if(doc.docs.isEmpty) {
          makeroom();
        }
        else {
          print("not empty");
          Navigator.push(context, MaterialPageRoute(
              builder: (context) =>
                  Chat(id: doc.docs.first.id, link: link,)),);
        }
      });

    }
  }

  void makeroom()async{
      print("empty");
      if (link != null || link.isNotEmpty) {
        await FirebaseFirestore.instance.collection(
            'rooms').add(
            {
              "host_link": link,
              "time": Timestamp.now()
            }

        ).then((value) async {
          await value.collection("messages").add({
            "msg": "Hi! Welcome to ChatIsDisabled!\nPlease feel free to use this site as a replacement for live chat.\nShare the URL to share the chat.",
            "time": Timestamp.fromDate(
                DateTime(2021, 11, 10)),
            "auth": "ChatIsDisabled"
          }).then((valuemsg) {
            //TODO: Get Docs again if empty

              Navigator.push(context, MaterialPageRoute(
                  builder: (context) =>
                      Chat(id: value.id, link: link)),);
              print("pressed and loaded");


          });
        }
        );

    }
  }
}
