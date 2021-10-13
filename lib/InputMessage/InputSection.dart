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
      child = SeatPicker(
          handleSubmit: this.handleSubmit,
          scrollController: this.scrollController);
    } else if (typeOfMessage == 'chips') {
      return child = Container(
        decoration: new BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.all(Radius.circular(45)),
        ),
        margin: EdgeInsets.only(bottom: 5),
        child: ListTile(
            title: Text(currentOption["label"]),
            leading: FlutterLogo(),
            onTap: () {
              print(currentOption);
              handleSubmit(currentOption["id"], currentOption["label"]);
            }),
      );
    } else if (typeOfMessage == 'confirm') {
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
