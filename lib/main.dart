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
  ScrollController messagesController = ScrollController();

  String _inputType = '';
  String introText = '';
  String intentId = '';
  List _optionsList = [];
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

    //add last message in the state messages list
    setState(() {
      _messages.insert(_messages.length, message);
      intentId = aiResponse.queryResult.intent.name;
    });
    //display last message with animation
    addAnimatedMessage();
    //scroll to the last messagee
    double itemOffset = messagesController.position.maxScrollExtent < 20
        ? messagesController.position.maxScrollExtent
        : messagesController.position.maxScrollExtent + 140;

    messagesController.animateTo(
      itemOffset,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );

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
      final intro = aiResponse.getListMessage()[1]["payload"]["intro"] ??
          'Choose an option:';

      setState(() {
        _inputType = type;
        _optionsList = optionsList;
        introText = intro;
      });
    }

    if (aiResponse.queryResult.intent.endInteraction) {
      _inputType = 'endInteraction';
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
      backgroundColor: Colors.blue[50],
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
          FractionallySizedBox(
              heightFactor: 0.7,
              child: Container(
                height: 430,
                color: Colors.blue[50],
                child: Center(
                    child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  child: AnimatedList(
                    controller: messagesController,
                    key: _key,
                    padding: EdgeInsets.fromLTRB(8.0, 20, 8, 150),
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
                )),
              )),
          DraggableScrollableSheet(
            maxChildSize: 0.7,
            initialChildSize: 0.5,
            minChildSize: 0.2,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  controller: scrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.62,
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Card(
                          elevation: 12.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  SizedBox(height: 12),
                                  CustomDraggingHandle(),
                                  SizedBox(height: 12),
                                  CustomTitleList(this.introText),
                                  SizedBox(height: 18),
                                  Column(
                                    children: (this._inputType.isNotEmpty)
                                        ? _optionsList != null
                                            ? this
                                                ._optionsList
                                                .map((currentOption) =>
                                                    InputSection(
                                                        handleSubmit:
                                                            this.handleSubmit,
                                                        inputController: this
                                                            ._inputController,
                                                        typeOfMessage:
                                                            this._inputType,
                                                        currentOption:
                                                            currentOption))
                                                .toList()
                                            : [
                                                InputSection(
                                                    handleSubmit:
                                                        this.handleSubmit,
                                                    inputController:
                                                        this._inputController,
                                                    typeOfMessage:
                                                        this._inputType,
                                                    collectedData:
                                                        this.collectedData)
                                              ]
                                        : [
                                            Container(
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            )
                                          ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ));
            },
          )
        ],
      ),
    );
  }
}

class CustomDraggingHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 30,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
    );
  }
}

class CustomTitleList extends StatelessWidget {
  CustomTitleList(this.introText);

  String introText;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(introText, style: TextStyle(fontSize: 22, color: Colors.black45)),
        SizedBox(width: 8),
        Container(
          height: 24,
          width: 24,
          child: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.black54),
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(16)),
        ),
      ],
    );
  }
}
