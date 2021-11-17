import 'dart:async';

import 'package:chatisdisabled/chat/chat_tile.dart';
import 'package:chatisdisabled/models/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:username_gen/username_gen.dart';

class Chat extends StatefulWidget {
  final String id;
  const Chat({Key? key, required this.id}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}


class _ChatState extends State<Chat> {
  String msg = "";
  String username = UsernameGen().generate();
  DateTime lastsend = DateTime.now();
  int count = 0;
  int delay = 1;

  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingController = TextEditingController();
  final _controller = ScrollController();
  final FocusNode node = FocusNode();




  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Expanded(
            child: Container(
              width: 1000,
              child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("rooms").doc(widget.id).collection("messages").orderBy('time').limit(100).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data != null && snapshot.data!.docs.length > 0) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        controller: _controller,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          Message msg = Message(doc);
                          return ChatTile(msg: msg);
                        }
                    );
                  }
                }
                return Center(
                  child: Text("Hi! There are no messages yet! Try sending one below!",
                      softWrap: true, style: TextStyle(color: Colors.grey,)),
                );
              }
                ) ) ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 300),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(

                      onFieldSubmitted: (value) async {

                          if (_formKey.currentState!.validate()) {
                            await FirebaseFirestore.instance.collection('rooms')
                                .doc(widget.id).collection('messages')
                                .add({
                              "msg": msg,
                              "time": Timestamp.fromDate(DateTime.now()),
                              "auth": username
                            });
                            _controller.animateTo(
                              _controller.position.maxScrollExtent,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.fastOutSlowIn,
                            );
                            _textEditingController.clear();
                            node.requestFocus();
                          }
                        },
                      autofocus: true,
                      focusNode: node,
                      textInputAction: TextInputAction.done,
                      controller: _textEditingController,

                      validator: (input){
                        if (DateTime.now().difference(lastsend).compareTo(
                        Duration(seconds: delay)) < 0 ) {
                          count += 1;
                          lastsend = DateTime.now();
                          if(count>=5){
                            delay = 30;
                            return 'You have been typing too fast and too much, wait 30 seconds';
                          }
                        } else {
                          delay = 1;
                          lastsend = DateTime.now();
                          count = 0;
                        }
                        if (input == null || input.isEmpty) {
                          return 'Please enter a message';
                        }
                      },
                      onChanged: (value) {
                        msg = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Message',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.animation),
                          onPressed: () async {
                            final gif = await GiphyPicker.pickGif(
                              previewType: GiphyPreviewType.fixedHeight,
                              showPreviewPage: false,
                              fullScreenDialog: false,
                                context: context,
                                apiKey: 'm7BMoujrp51fGYZEzLkPhXRZrvWiJDvQ');

                            await FirebaseFirestore.instance.collection('rooms').doc(widget.id).collection('messages').add({
                              "msg" : gif!.images.downsizedLarge!.url!.trim(),
                              "time" : Timestamp.now(),
                              "auth" : username
                            });
                            _controller.animateTo(
                              _controller.position.maxScrollExtent,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.fastOutSlowIn,
                            );
                            node.requestFocus();

                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
