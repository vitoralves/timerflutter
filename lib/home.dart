import 'dart:async';

import 'package:wakelock/wakelock.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _total = 0;
  int _pausedAt = 0;
  bool _paused = false;

  void _setTime() {
    setState(() {
      _total = 600;
    });
    Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) => setState(() {
              if (!_paused) {
                if (_total == 0) {
                  timer.cancel();
                } else {
                  _total = _total - 1;
                }
              } else {
                if (_pausedAt > 0) {
                  _total = _pausedAt;
                }
              }
            }));
  }

  void _pause() {
    setState(() {
      _paused = !_paused;
      _pausedAt = _total;
    });
  }

  void _reset() {
    setState(() {
      _total = 0;
      _pausedAt = 0;
      _paused = false;
    });
  }

  Color _getColor() {
    if (_total > 300) {
      return Colors.green;
    } else if (_total > 250) {
      return Colors.yellow;
    } else if (_total == 0) {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      Wakelock.enable();
    });
    return Scaffold(
      body: GestureDetector(
        child: Container(
          color: _getColor(),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: _total == 0
                ? FlatButton(
                    onPressed: _setTime,
                    child: Text(
                      'INICIAR',
                      style: TextStyle(
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Text(
                    DateFormat.ms().format(
                        DateTime.fromMillisecondsSinceEpoch(_total * 1000)),
                    style: TextStyle(
                      fontSize: 90,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
          ),
        ),
        onTap: _pause,
        onLongPress: _reset,
      ),
    );
  }
}
