import 'package:chatbot/InputMessage/components/DatePicker.dart';
import 'package:chatbot/InputMessage/components/Recap.dart';
import 'package:chatbot/InputMessage/components/SeatPicker.dart';
import 'package:flutter/material.dart';

class InputSection extends StatelessWidget {
  const InputSection(
      {Key key,
      this.typeOfMessage,
      this.currentOption,
      this.handleSubmit,
      this.inputController,
      this.scrollController,
      this.collectedData})
      : super(key: key);

  final String typeOfMessage;
  final Map currentOption;
  final Function handleSubmit;
  final TextEditingController inputController;
  final Map collectedData;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (typeOfMessage == 'date') {
      child = DatePicker(
        handleSubmit: this.handleSubmit,
      );
    } else if (typeOfMessage == 'grid') {
      child = SeatPicker(handleSubmit: this.handleSubmit);
    } else if (typeOfMessage == 'chips') {
      return child = Container(
        height: 50,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo[50],
              blurRadius: 10.0, // soften the shadow
              spreadRadius: 5.0, //extend the shadow
              offset: Offset(
                1.0, // Move to right 10  horizontally
                8.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        margin: EdgeInsets.only(bottom: 9),
        child: ListTile(
            title: Text(currentOption["label"]),
            leading: FlutterLogo(),
            onTap: () {
              handleSubmit(
                  currentOption["id"], "I'd like to ${currentOption["label"]}");
            }),
      );
    } else if (typeOfMessage == 'endInteraction') {
      child = Recap(
        collectedData: this.collectedData,
        handleSubmit: this.handleSubmit,
      );
    } else {
      child = ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(
                250, 50), // double.infinity is the width and 30 is the height
          ),
          child: Text('restart'),
          onPressed: () => this.handleSubmit('restart'));
    }

    return child;
  }
}
