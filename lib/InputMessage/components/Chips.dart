import 'package:flutter/material.dart';

class CustomChips extends StatelessWidget {
  CustomChips({this.optionsList, this.handleSubmit});
  List optionsList;
  Function handleSubmit;

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 10.0, // gap between adjacent chips
        runSpacing: 10.0,
        children: optionsList
            .map((option) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ActionChip(
                    labelPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    avatar: CircleAvatar(
                      backgroundColor: Colors.white70,
                      child: Text(option["label"][0].toUpperCase()),
                    ),
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
                    })))
            .toList());
  }
}
