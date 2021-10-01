import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  DatePicker({Key key, this.handleSubmit}) : super(key: key);

  Function handleSubmit;

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("${selectedDate.toLocal()}".split(' ')[0]),
          SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select date'),
          ),
          ElevatedButton(
            onPressed: () =>
                widget.handleSubmit(selectedDate.toString().substring(0, 10)),
            child: Text('Confirm Date'),
          )
        ],
      ),
    );
  }
}
