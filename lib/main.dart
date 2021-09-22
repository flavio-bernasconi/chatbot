import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'ChatMessages/ChatMessages.dart';

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
  final List<ChatMessages> _messages = <ChatMessages>[];
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
    AIResponse response = await dialogflow.detectIntent(query);

    ChatMessage message = ChatMessage(
      message: aiResponse.getMessage(),
    ChatMessages message = ChatMessages(
      message: response.getMessage(),
      name: "Bot",
      isUserMessage: false,
    );

    final isProjectNameIntent =
        response.queryResult.parameters.containsKey('projectName');

    if (isProjectNameIntent) {
      setState(() {
        setState(() {
          _messages.insert(0, message);
        });
        _messages.insert(
            0,
            ChatMessages(
                message: '',
                name: "Bot",
                isUserMessage: false,
                typeOfMessage: 'image'));
      });
    } else {
      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  void _handleSubmit(String text) {
    if (_inputController.text.isEmpty) return print('empty message');
    _inputController.clear();

    ChatMessages message = ChatMessages(
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
