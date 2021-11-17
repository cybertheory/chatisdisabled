import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:username_gen/username_gen.dart';

class Message {
  String msg = "";
  String auth = "";
  Timestamp time = Timestamp.now();

  Message(DocumentSnapshot doc){
    msg = doc.get("msg");
    try {
      auth = doc.get("auth");
    }catch (error){
      auth = "No author";
    }
    time = doc.get("time");
  }

}