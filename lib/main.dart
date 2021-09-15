import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePageDialogflow(),
    );
  }
}

// -------------------------------------------
// Home create state
// -------------------------------------------
class HomePageDialogflow extends StatefulWidget {
  HomePageDialogflow({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageDialogflow createState() => _HomePageDialogflow();
}

// -------------------------------------------
// Chat logic
// -------------------------------------------
class _HomePageDialogflow extends State<HomePageDialogflow> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _inputController = TextEditingController();

  Widget _inputMessageBar() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        margin: EdgeInsets.only(bottom: 10.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _inputController,
                onSubmitted: _handleSubmit,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(children: [
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _handleSubmit(_inputController.text),
                  ),
                  IconButton(
                    icon: Icon(Icons.addchart_rounded),
                    onPressed: () => _handleSubmit(_inputController.text),
                  )
                ])),
          ],
        ),
      ),
    );
  }

  void sendQueryToDialogFlow(query) async {
    _inputController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/config.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    print(aiResponse);

    ChatMessage message = ChatMessage(
      message: aiResponse.getMessage(),
      name: "Bot",
      isUserMessage: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmit(String text) {
    if (_inputController.text.isEmpty) return print('empty message');
    _inputController.clear();

    ChatMessage message = ChatMessage(
      message: text,
      name: "User",
      isUserMessage: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    sendQueryToDialogFlow(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chatbotto"),
      ),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, index) => _messages[index],
          itemCount: _messages.length,
        )),
        Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(color: Colors.white10),
          child: _inputMessageBar(),
        ),
      ]),
    );
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.message, this.name, this.isUserMessage});

  final String message;
  final String name;
  final bool isUserMessage;

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

  messageContainer(String message) {
    return Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
      child: Text(message),
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(color: Colors.grey[200]),
    );
  }

  List<Widget> botMessage(context) {
    return <Widget>[
      createAvatar(this.name),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(this.name, style: TextStyle(fontWeight: FontWeight.bold)),
            messageContainer(this.message)
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(this.name,
                style: TextStyle(
                    backgroundColor: Colors.blue[50],
                    fontWeight: FontWeight.bold)),
            messageContainer(this.message)
          ],
        ),
      ),
      createAvatar(this.name, Colors.white, Colors.teal[300]),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.isUserMessage ? myMessage(context) : botMessage(context),
      ),
    );
  }
}
