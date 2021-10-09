import 'package:flutter/material.dart';
import 'Components/Avatar.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({
    this.message,
    this.name,
    this.isUserMessage,
  });

  final String message;
  final String name;
  final bool isUserMessage;

  final Map<String, Color> botAvatarConfig = {
    'color': Colors.white,
    'background': Colors.orange[500]
  };

  messageContainer() {
    return Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
      child: Text(message),
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.all(15.0),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0, // soften the shadow
            spreadRadius: 5.0, //extend the shadow
            offset: Offset(
              4.0, // Move to right 10  horizontally
              8.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
    );
  }

  List<Widget> botMessage() {
    return <Widget>[
      Avatar(name: this.name),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text(this.name, style: TextStyle(fontWeight: FontWeight.bold)),
            messageContainer()
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage() {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // Text(this.name,
            //     style: TextStyle(
            //         backgroundColor: Colors.blue[50],
            //         fontWeight: FontWeight.bold)),
            messageContainer()
          ],
        ),
      ),
      Avatar(
          name: this.name,
          textColor: Colors.white,
          background: Colors.teal[300]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.isUserMessage ? myMessage() : botMessage(),
      ),
    );
  }
}
