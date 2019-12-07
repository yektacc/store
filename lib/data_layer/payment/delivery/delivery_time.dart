import 'package:flutter/material.dart';
import 'package:store/common/constants.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';

class DayOfMonth {
  final int day;
  final int month;
  final String monthName;

  @override
  bool operator ==(other) {
    return other is DayOfMonth && day == other.day && month == other.month;
  }

  @override
  int get hashCode {
    return hash2(day, month);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'day': day,
      'month': month,
      'month_name': monthName
    };
  }

  DayOfMonth(this.day, this.month, this.monthName);
}

class DeliveryTimePicker extends StatefulWidget {
  final List<DayOfMonth> availableDaysOfMonth;
  final BehaviorSubject<List<DayOfMonth>> selectedDay;
  final BehaviorSubject<int> selectedHourFrom;
  final BehaviorSubject<int> selectedHourTo;
  final VoidCallback onNextTapped;

  DeliveryTimePicker(this.availableDaysOfMonth, this.selectedDay,
      this.selectedHourFrom, this.selectedHourTo, this.onNextTapped);

  @override
  _DeliveryTimePickerState createState() => _DeliveryTimePickerState();
}

class _DeliveryTimePickerState extends State<DeliveryTimePicker> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      width: 300,
      color: Colors.grey[100],
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 14),
            alignment: Alignment.center,
            child: Text("روز دریافت"),
          ),
          Expanded(
            child: StreamBuilder<List<DayOfMonth>>(
                stream: widget.selectedDay,
                builder: (context, snapshot) {
                  return Row(
                    children: widget.availableDaysOfMonth
                        .map((dom) => Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    if (widget.selectedDay.value != null) {
                                      if (!widget.selectedDay.value
                                          .contains(dom)) {
                                        widget.selectedDay.add(
                                            widget.selectedDay.value + [dom]);
                                      } else {
                                        var newList = widget.selectedDay.value;
                                        newList.remove(dom);

                                        widget.selectedDay.add(newList);
                                      }
                                    }
                                  },
                                  child: snapshot.data != null
                                      ? DeliveryDayItem(
                                          dom, snapshot.data.contains(dom))
                                      : Container()),
                            ))
                        .toList(),
                  );
                }),
          ),
          Container(
            child: Text('ساعت دریافت'),
          ),
          Expanded(
            child: Container(
                alignment: Alignment.center,
                child: StreamBuilder<int>(
                    stream: widget.selectedHourTo,
                    builder: (context, hourToSnp) {
                      return new Row(
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(right: 40, left: 40),
                            child: Text('از'),
                          ),
                          new Expanded(
                            child: DropdownButton<int>(
                              value: hourToSnp.data,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(color: AppColors.main_color),
                              onChanged: widget.selectedHourTo.add,
                              items: [
                                -1,
                                7,
                                8,
                                9,
                                10,
                                11,
                                12,
                                13,
                                14,
                                15,
                                16,
                                17,
                                18
                              ].map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(
                                      value != -1 ? value.toString() : 'ساعت'),
                                );
                              }).toList(),
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.only(right: 40, left: 40),
                            child: Text('تا'),
                          ),
                          new Expanded(
                            child: new StreamBuilder<int>(
                                stream: widget.selectedHourFrom,
                                builder: (context, hourFromSnp) {
                                  if (hourFromSnp.data != null &&
                                      hourToSnp.data != null &&
                                      hourFromSnp.data <= hourToSnp.data) {
                                    widget.selectedHourFrom.add(-1);
                                  }

                                  var items;
                                  if (hourToSnp.data != -1) {
                                    items = [
                                          -1,
                                          7,
                                          8,
                                          9,
                                          10,
                                          11,
                                          12,
                                          13,
                                          14,
                                          15,
                                          16,
                                          17,
                                          18
                                        ]
                                            .where((hourFrom) =>
                                                hourFrom > hourToSnp.data)
                                            .toList() +
                                        [-1];
                                  }
                                  return DropdownButton<int>(
                                    value: hourFromSnp.data,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style:
                                        TextStyle(color: AppColors.main_color),
                                    onChanged: widget.selectedHourFrom.add,
                                    items: items == null
                                        ? null
                                        : items.map<DropdownMenuItem<int>>(
                                            (int value) {
                                            return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text(value != -1
                                                  ? value.toString()
                                                  : 'ساعت'),
                                            );
                                          }).toList(),
                                  );
                                }),
                          ),
                        ],
                      );
                    })),
          ),
          GestureDetector(
            onTap: widget.onNextTapped,
            child: GotoPaymentBottomBar(true),
          )
        ],
      ),
    );
  }
}

class DeliveryDayItem extends StatelessWidget {
  bool isSelected;
  final DayOfMonth dom;

  DeliveryDayItem(this.dom, this.isSelected);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? AppColors.main_color : Colors.grey[50],
      child: Container(
        padding: EdgeInsets.only(top: 5),
        height: 50,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Text(
                dom.day.toString(),
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87),
              ),
            ),
            Expanded(
              child: Text(
                dom.monthName,
                style: TextStyle(
                    fontSize: 10,
                    color: isSelected ? Colors.white : Colors.black87),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GotoPaymentBottomBar extends StatelessWidget {
  final bool enabled;

  GotoPaymentBottomBar(this.enabled);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: enabled ? AppColors.main_color : Colors.grey[100],
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 8,
                ),
                child: Icon(Icons.payment,
                    color: enabled ? Colors.white : Colors.grey[500]),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "پرداخت",
                style: TextStyle(
                    color: enabled ? Colors.white : AppColors.main_color,
                    fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
