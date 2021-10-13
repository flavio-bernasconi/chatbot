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
  GlobalKey<AnimatedListState> _key = GlobalKey();

  String _inputType = '';
  List _optionsList = [];
  String intentId = '';
  Map collectedData = {};

  void resetState() {
    setState(() {
      _messages = [];
      _inputType = '';
      _optionsList = [];
      collectedData = {};
      intentId = '';
      _key = GlobalKey();
    });
    return sendQueryToDialogFlow('hi');
  }

  void addAnimatedMessage() {
    _key.currentState.insertItem(_messages.length - 1,
        duration: Duration(milliseconds: 600));
  }

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
      _messages.insert(_messages.length, message);
      intentId = aiResponse.queryResult.intent.name;
    });
    addAnimatedMessage();

    if (listKeys[intentId] == "restart") {
      resetState();
    }

    if (aiResponse.queryResult.parameters.keys.toList().length > 0 == true) {
      //TODO use map add all parameters
      print(aiResponse.queryResult.parameters.keys);
      print(aiResponse.queryResult.parameters.values);
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
    }

    if (aiResponse.queryResult.intent.endInteraction) {
      _inputType = 'confirm';
      _optionsList = null;
    }

    if (_inputType.isEmpty) {
      _inputType = 'restart';
    }
  }

  void handleSubmit(String textForDialogFlow, [String textMessage]) {
    if (textForDialogFlow.isEmpty && textMessage == null)
      return print('empty message');

    ChatMessages message = ChatMessages(
      message: textMessage ?? textForDialogFlow,
      name: "User",
      isUserMessage: true,
    );

    setState(() {
      _messages.insert(_messages.length, message);
      _inputType = '';
      _optionsList = [];
    });
    addAnimatedMessage();
    sendQueryToDialogFlow(textForDialogFlow);
  }

  @override
  void initState() {
    sendQueryToDialogFlow('hi');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Chat boot"),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh_rounded),
          elevation: 5,
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          onPressed: () => handleSubmit('restart')),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            bottom: 70,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              child: AnimatedList(
                key: _key,
                padding: EdgeInsets.fromLTRB(8.0, 20, 8, 50),
                // reverse: true,
                itemBuilder: (_, index, animation) => SlideTransition(
                  key: UniqueKey(),
                  position: Tween<Offset>(
                    begin: Offset(index.isEven ? -1 : 1, 0),
                    end: Offset(0, 0),
                  ).animate(animation),
                  child: _messages[index],
                ),
                initialItemCount: 0,
              ),
            ),
          ),
          DraggableScrollableSheet(
            maxChildSize: 0.5,
            initialChildSize: 0.3,
            minChildSize: 0.1,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                  height: 0.3,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0, // soften the shadow
                        spreadRadius: 25.0, //extend the shadow
                        offset: Offset(
                          0,
                          19.0,
                        ),
                      )
                    ],
                  ),
                  child: (this._inputType.isNotEmpty)
                      ? _optionsList != null
                          ? ListView.builder(
                              controller: scrollController,
                              itemCount: _optionsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  // decoration: BoxDecoration(color: Colors.red),
                                  child: InputSection(
                                      handleSubmit: this.handleSubmit,
                                      inputController: this._inputController,
                                      typeOfMessage: this._inputType,
                                      currentOption: this._optionsList[index]),
                                );
                              })
                          : SingleChildScrollView(
                              controller: scrollController,
                              child: InputSection(
                                  handleSubmit: this.handleSubmit,
                                  inputController: this._inputController,
                                  typeOfMessage: this._inputType,
                                  scrollController: scrollController,
                                  collectedData: this.collectedData))
                      : Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ));
            },
          )
        ],
      ),
    );
  }
}

// InputSection(
//                   handleSubmit: this.handleSubmit,
//                   inputController: this._inputController,
//                   typeOfMessage: this._inputType,
//                   optionsList: this._optionsList)
