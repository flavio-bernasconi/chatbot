import 'package:flutter/material.dart';
import 'dart:math';

class SeatPicker extends StatefulWidget {
  SeatPicker({Key key, this.handleSubmit}) : super(key: key);

  final Function handleSubmit;

  @override
  _SeatPickerState createState() => _SeatPickerState();
}

class _SeatPickerState extends State<SeatPicker> {
  int selectedSeat = 1;
  int limitSeats = 0;
  List<int> _notAvailableSeats = [];
  List<int> _emptySeats = [];
  List<Map> locationSeats = [];

  @override
  void initState() {
    super.initState();
    limitSeats = 200;
    _notAvailableSeats =
        List<int>.generate(40, (int index) => Random().nextInt(limitSeats));
    _emptySeats = List<int>.generate(
        limitSeats - 30, (int index) => Random().nextInt(limitSeats));

    locationSeats = List.generate(
        200,
        (index) => {
              "id": index,
              "name": (index + 1).toString(),
              "isAvailable": !_notAvailableSeats.contains(index),
              "isEmptySpace": index != 0 && index % 4 == 0,
            }).toList();
  }

  @override
  Widget build(BuildContext context) {
    print(locationSeats);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LegendItem(
              color: Colors.amber,
              text: 'selected',
            ),
            LegendItem(
              color: Colors.blue[100],
              text: 'available',
            ),
            LegendItem(
              color: Colors.grey,
              text: 'unavailable',
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        SizedBox(
            height: 200,
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: locationSeats.length,
                itemBuilder: (BuildContext ctx, index) {
                  return InkWell(
                    onTap: () {
                      if (locationSeats[index]["isAvailable"] &&
                          !locationSeats[index]["isEmptySpace"]) {
                        setState(() {
                          selectedSeat = index;
                        });
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(locationSeats[index]["id"] == selectedSeat
                          ? locationSeats[index]["name"]
                          : ''),
                      decoration: BoxDecoration(
                          color: locationSeats[index]["id"] == selectedSeat
                              ? Colors.amber
                              : locationSeats[index]["isEmptySpace"]
                                  ? Colors.grey[100]
                                  : locationSeats[index]["isAvailable"]
                                      ? Colors.blue[100]
                                      : Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                })),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          child: Text('button'),
          onPressed: () => widget.handleSubmit(selectedSeat.toString()),
        ),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  LegendItem({this.color, this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            height: 15.0,
            width: 15.0,
            margin: EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(4))),
        Text(text)
      ],
    );
  }
}
