
import 'dart:async';
import 'dart:ui';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Colors.transparent,
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour = int.parse(DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh')
        .format(_dateTime));
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'DS-DIGII',
      fontSize: fontSize,
      fontStyle: FontStyle.italic,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(3, 0),
        ),
      ],
    );

    return Stack(
      fit: StackFit.expand,
      children: (6 > hour && hour < 18)
          ? <Widget>[
              Image(
                image: AssetImage('assets/day.jpg'),
                fit: BoxFit.cover,
              )
            ]
          : <Widget>[
              Image(
                image: AssetImage('assets/nighty.jpg'),
                fit: BoxFit.cover,
              ),
              Container(
                child: Center(
                  child: DefaultTextStyle(
                    style: defaultStyle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          hour.toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: (6 > hour && hour < 18)
                                    ? <Widget>[
                                        Icon(Icons.wb_sunny,
                                            color: Colors.amber),
                                        Icon(
                                          Icons.wb_sunny,
                                          color: Colors.amber,
                                        )
                                      ]
                                    : <Widget>[
                                        Icon(
                                          IconData(0xe800, fontFamily: 'Night'),
                                          color: Colors.white,
                                        ),
                                        Icon(
                                          IconData(0xe800, fontFamily: 'Night'),
                                          color: Colors.white,
                                        ),
                                      ]),
                          ),
                        ),
                        Text(
                          minute,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
    );
  }
}
