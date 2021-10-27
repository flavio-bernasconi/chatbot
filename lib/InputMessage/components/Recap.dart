import 'package:flutter/material.dart';

Widget getTextWidgets(Map collectedData) {
  return Row(
      children: collectedData.keys
          .map((key) => Row(
                children: [Text('$key: ${collectedData[key]}')],
              ))
          .toList());
}

class Recap extends StatelessWidget {
  Recap({Key key, this.handleSubmit, this.collectedData}) : super(key: key);

  Function handleSubmit;
  Map collectedData;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            for (var key in collectedData.keys)
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text('$key: ${collectedData[key].toString()}')],
                ),
              ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  child: Text('Restart'),
                  onPressed: () => this.handleSubmit('restart')),
              ElevatedButton(
                  child: Text('Confirm'),
                  onPressed: () {
                    print('url-save-data then restart');
                    this.handleSubmit('restart');
                  })
            ],
          ),
        )
      ],
    ));
  }
}
