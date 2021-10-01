import 'package:chatbot/InputMessage/components/Chips.dart';
import 'package:chatbot/InputMessage/components/InputBar.dart';
import 'package:chatbot/InputMessage/components/DatePicker.dart';
import 'package:chatbot/InputMessage/components/SeatPicker.dart';
import 'package:flutter/material.dart';

class InputSection extends StatelessWidget {
  const InputSection(
      {Key key,
      this.typeOfMessage,
      this.optionsList,
      this.handleSubmit,
      this.inputController})
      : super(key: key);

  final String typeOfMessage;
  final List optionsList;
  final Function handleSubmit;
  final TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    double height = 70.0;
    Widget child;

    if (typeOfMessage == 'chips') {
      height = 280.0;
      child = CustomChips(optionsList: optionsList, handleSubmit: handleSubmit);
    } else if (typeOfMessage == 'date') {
      height = 280.0;
      child = DatePicker(
        handleSubmit: this.handleSubmit,
      );
    } else if (typeOfMessage == 'grid') {
      height = 480.0;
      child = SeatPicker(
        handleSubmit: this.handleSubmit,
      );
    } else {
      height = 110.0;
      child = ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(
                250, 50), // double.infinity is the width and 30 is the height
          ),
          child: Text('restart'),
          onPressed: () => this.handleSubmit('restart'));
    }

    return Container(
      height: height,
      alignment: Alignment.topCenter,
      decoration: new BoxDecoration(
          color: Colors.teal[50],
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(40.0),
            topRight: const Radius.circular(40.0),
          )),
      child: Container(
        height: height,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

// else if (typeOfMessage == 'chips2') {
//       child = ListView(
//           scrollDirection: Axis.horizontal,
//           children: optionsList
//               .map((option) => Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 10.0),
//                   child: CustomChip(
//                     id: option["id"],
//                     handleSubmit: this.handleSubmit,
//                     label: option["label"],
//                     color: Color(0xFFff6666),
//                   )))
//               .toList());
//     }
