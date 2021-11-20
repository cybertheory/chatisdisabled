import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:username_gen/username_gen.dart';

class Message {
  String msg = "";
  String auth = "";
  Timestamp time = Timestamp.now();
  String type = "social";

  Message(String msg, {String? auth = "", String? type = "social"}){
    this.msg = msg;
    this.auth = auth!;
    this.time = Timestamp.now();
    this.type = type!;
  }

  Message.fromDoc(DocumentSnapshot doc){
    msg = doc.get("msg");
    try {
      auth = doc.get("auth");
    }catch (error){
      auth = "No author";
    }
    time = doc.get("time");
    try {
      type = doc.get("type");
    }catch (error){
      type = "social";
    }
  }

}