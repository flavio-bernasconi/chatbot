import 'package:flutter/material.dart';
import 'components/MessageContainer.dart';

class ChatMessages extends StatefulWidget {
  ChatMessages(
      {Key key,
      this.title,
      this.message,
      this.name,
      this.isUserMessage,
      this.typeOfMessage})
      : super(key: key);

  final String title;
  final String message;
  final String name;
  final bool isUserMessage;
  final String typeOfMessage;

  @override
  _ChatMessages createState() => _ChatMessages();
}

class _ChatMessages extends State<ChatMessages>
    with AutomaticKeepAliveClientMixin {
  final Map<String, Color> botAvatarConfig = {
    'color': Colors.white,
    'background': Colors.orange[500]
  };

  createAvatar(String name, [Color textColor, Color background]) {
    return Container(
        margin: const EdgeInsets.all(10.0),
        child: CircleAvatar(
            backgroundColor: background ?? botAvatarConfig['background'],
            child: Text(
              name[0],
              style: TextStyle(
                  color: textColor ?? botAvatarConfig['color'],
                  fontWeight: FontWeight.bold),
            )));
  }

  createCarousel() {
    return Center(
      child: SizedBox(
        height: 250, // card height
        child: PageView.builder(
          itemCount: 10,
          controller: PageController(viewportFraction: 0.7),
          itemBuilder: (_, i) {
            return Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://images.squarespace-cdn.com/content/v1/52127948e4b06d5f9d345a0f/1511952706067-1FX8HOO8RLD4W7TJYWKE/WEB.png?format=1000w",
                    ),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Text("YOUR TEXT"),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
            );
          },
        ),
      ),
    );
  }

  // messageContainer(String message) {
  //   return Container(
  //     constraints: BoxConstraints(
  //         minWidth: 100, maxWidth: typeOfMessage != "image" ? 200 : 430),
  //     child: typeOfMessage != "image" ? Text(message) : createCarousel(),
  //     margin: EdgeInsets.only(top: 5.0),
  //     padding: EdgeInsets.all(10.0),
  //     decoration: BoxDecoration(color: Colors.grey[200]),
  //   );
  // }

  List<Widget> botMessage() {
    return <Widget>[
      createAvatar(widget.name),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold)),
            MessageContainer()
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
            Text(widget.name,
                style: TextStyle(
                    backgroundColor: Colors.blue[50],
                    fontWeight: FontWeight.bold)),
            MessageContainer()
          ],
        ),
      ),
      createAvatar(widget.name, Colors.white, Colors.teal[300]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    print(widget.key);
    super.build(context);
    return Container(
      margin: const EdgeInsets.only(top: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.isUserMessage ? myMessage() : botMessage(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
