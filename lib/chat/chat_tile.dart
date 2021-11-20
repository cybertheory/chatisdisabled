import 'package:chatisdisabled/models/messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:giphy_picker/giphy_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatTile extends StatelessWidget {
  final Message msg;

  const ChatTile({Key? key, required this.msg,}) : super(key: key);
  static List<Color> colors = [Colors.red, Colors.red[200]!, Colors.purple, Colors.purple[200]!, Colors.pink, Colors.pink[200]!, Colors.blue, Colors.blue[200]!, Colors.orange,  Colors.orange[200]!];
  @override
  Widget build(BuildContext context) {
    bool isGiphy = msg.msg.contains(".giphy.com/media/") && msg.msg.split(" ").length==1;
    Widget gif = GiphyImage(url: msg.msg, renderGiphyOverlay: false,);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         msg.type == "social" ? Text(msg.auth,
            softWrap: true, style: TextStyle(color: colors[msg.auth.codeUnitAt(0)%colors.length]),) : Container(),
    msg.type != "confetti" ? SizedBox(height: 10,): Container(),
         isGiphy ? gif :
         SelectableLinkify(
           style: TextStyle(color: msg.type != "social" ? Colors.grey : Colors.black),
           onOpen: (link) async {
           if (await canLaunch(link.url)) {
             await launch(link.url);
           } else {
             throw 'Could not launch $link';
           }
         }, text: msg.type != "confetti" ? msg.msg : msg.auth + " celebrated with CONFETTI",
         options: LinkifyOptions(looseUrl: true),) ,
        ],
      ),
    );
  }
}
