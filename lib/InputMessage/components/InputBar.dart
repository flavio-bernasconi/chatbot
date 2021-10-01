import 'package:flutter/material.dart';

class InputBar extends StatelessWidget {
  InputBar({this.handleSubmit, this.inputController});

  Function handleSubmit;
  TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: inputController,
                onSubmitted: handleSubmit,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(children: [
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => handleSubmit(inputController.text),
                  ),
                  IconButton(
                    icon: Icon(Icons.addchart_rounded),
                    onPressed: () => handleSubmit(inputController.text),
                  )
                ])),
          ],
        ),
      ),
    );
  }
}
