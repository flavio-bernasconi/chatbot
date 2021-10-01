import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'ChatMessages/ChatMessages.dart';
import 'InputMessage/InputSection.dart';
import 'package:flutter/foundation.dart';

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

Map<String, String> listKeys = {
  "projects/mikey-yoiy/agent/intents/8d3692dd-e027-4a55-9aa5-2f9dc38b247b":
      "restart"
};

// -------------------------------------------
// Chat logic
// -------------------------------------------
class _HomePageDialogflow extends State<HomePageDialogflow> {
  List<ChatMessages> _messages = <ChatMessages>[];
  TextEditingController _inputController = TextEditingController();
  String _inputType = '';
  List _optionsList = [];
  String intentId = '';
  Map collectedData = {};

  void sendQueryToDialogFlow(query) async {
    _inputController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/config.json").build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);

    ChatMessages message = ChatMessages(
      message: aiResponse.getMessage(),
      name: "Bot",
      isUserMessage: false,
    );

    setState(() {
      _messages.insert(0, message);
      intentId = aiResponse.queryResult.intent.name;
    });

    if (listKeys[intentId] == "restart") {
      setState(() {
        _messages = [];
        _inputType = '';
        _optionsList = [];
        collectedData = {};
        intentId = '';
      });
      return sendQueryToDialogFlow('hi');
    }

    if (aiResponse.queryResult.parameters.keys.toList().length > 0 == true) {
      setState(() {
        collectedData[aiResponse.queryResult.parameters.keys.toList()[0]] =
            aiResponse.queryResult.parameters.values.toList()[0];
      });
    }

    if (aiResponse.getListMessage().length > 1) {
      final type = aiResponse.getListMessage()[1]["payload"]["type"];
      final optionsList =
          aiResponse.getListMessage()[1]["payload"]["listValues"];

      setState(() {
        _inputType = type;
        _optionsList = optionsList;
      });
    } else {
      setState(() {
        _inputType = 'text';
      });
    }
  }

  void handleSubmit(String text) {
    if (text.isEmpty) return print('empty message');
    // print(text);

    ChatMessages message = ChatMessages(
      message: text,
      name: "User",
      isUserMessage: true,
    );

    setState(() {
      _messages.insert(0, message);
      _inputType = '';
      _optionsList = [];
    });

    sendQueryToDialogFlow(text);
  }

  @override
  void initState() {
    sendQueryToDialogFlow('hi');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chat boot"),
      ),
      body: Column(children: <Widget>[
        Flexible(
            child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, index) => _messages[index],
          itemCount: _messages.length,
        )),
        Container(
          decoration: BoxDecoration(color: Colors.white10),
          child: (this._inputType.isNotEmpty)
              ? InputSection(
                  handleSubmit: this.handleSubmit,
                  inputController: this._inputController,
                  typeOfMessage: this._inputType,
                  optionsList: this._optionsList)
              : LinearProgressIndicator(
                  minHeight: 20.0,
                ),
        ),
      ]),
    );
  }
}
