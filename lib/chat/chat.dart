import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String id;
  const Chat({Key? key, required this.id}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String msg = "";
  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    print(widget.id);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
        StreamBuilder(stream: FirebaseFirestore.instance.collection("rooms").doc(widget.id).collection("messages").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container( width: 500 ,child: Text(snapshot.data!.docs[index].get("msg"), softWrap: true,));
          });
        }),
        Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  validator: (input){
                    if (input == null || input.isEmpty) {
                      return 'Please enter a message';
                    }
                  },
                  onChanged: (value) {
                    msg = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter Twitch/Youtube Live Stream Link',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('rooms').doc(widget.id).collection('messages').add({
                      "msg" : msg,
                    });
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }
}
