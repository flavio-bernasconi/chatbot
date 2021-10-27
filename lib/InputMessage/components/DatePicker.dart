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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  Icons.calendar_today,
                ),
                iconSize: 34,
                color: Colors.grey[700],
                onPressed: () => _selectDate(context),
              ),
              InkWell(
                child: Text("${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 40)),
                onTap: () => _selectDate(context),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => widget
                    .handleSubmit(selectedDate.toString().substring(0, 10)),
                child: Text('Confirm Date'),
                style: ElevatedButton.styleFrom(
                    primary: Colors.indigo[400],
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    textStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.normal)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
