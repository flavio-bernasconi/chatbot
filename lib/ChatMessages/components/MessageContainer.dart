import 'dart:async';
import 'package:flutter/material.dart';

class MessageContainer extends StatefulWidget {
  MessageContainer({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MessageContainer createState() => _MessageContainer();
}

class _MessageContainer extends State<MessageContainer> {
  bool isLoading = true;
  Timer _timer;

  @override
  void initState() {
    print('rendeer _MessageContainer');

    _timer = new Timer(const Duration(milliseconds: 3000), () {
      setState(() {
        isLoading = false;
      });
    }); //call load data on start
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 430),
      child: isLoading ? CircularProgressIndicator() : Text('finish'),
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(color: Colors.grey[200]),
    );
  }
}
