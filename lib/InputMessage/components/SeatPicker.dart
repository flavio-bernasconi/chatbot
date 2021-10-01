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
  List<Map> locationSeats = [];

  @override
  void initState() {
    super.initState();
    limitSeats = 200;
    _notAvailableSeats =
        List<int>.generate(40, (int index) => Random().nextInt(limitSeats));

    locationSeats = List.generate(
        200,
        (index) => {
              "id": index,
              "name": index.toString(),
              "isAvailable": !_notAvailableSeats.contains(index),
            }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
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
                          if (locationSeats[index]["isAvailable"]) {
                            setState(() {
                              selectedSeat = index;
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(locationSeats[index]["name"]),
                          decoration: BoxDecoration(
                              color: locationSeats[index]["id"] == selectedSeat
                                  ? Colors.amber
                                  : locationSeats[index]["isAvailable"]
                                      ? Colors.blue[100]
                                      : Colors.grey,
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      );
                    })),
            Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(250,
                              50), // double.infinity is the width and 30 is the height
                        ),
                        child: Text('Selected workstation $selectedSeat'),
                        onPressed: () =>
                            widget.handleSubmit(selectedSeat.toString())),
                    Container(
                        width: 80.0,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              if (value.isEmpty) {
                                return selectedSeat = 1;
                              }
                              if (int.parse(value) < limitSeats) {
                                selectedSeat = int.parse(value);
                              } else {
                                selectedSeat = limitSeats;
                              }
                            });
                          },
                          style: TextStyle(color: Colors.blue),
                          decoration: InputDecoration(
                              hintText: 'Type here...',
                              fillColor: Colors.white,
                              filled: true),
                        ))
                  ],
                ))
          ],
        ));
  }
}
