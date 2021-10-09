import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  CustomChip({Key key, this.option, this.handleSubmit}) : super(key: key);

  Map option;
  Function handleSubmit;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        // avatar: CircleAvatar(
        //   backgroundColor: Colors.white70,
        //   child: Text(option["label"][0].toUpperCase()),
        // ),
        label: Text(
          option["label"],
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal[500],
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
        onPressed: () {
          handleSubmit(option["id"]);
        });
  }
}
