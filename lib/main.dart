import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/async.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Metronome',
      home: new MetronomeClass(),
    );
  }
}

class MetronomeClass extends StatefulWidget {
  @override
  createState() => new MetronomeState();
}

class MetronomeState extends State<MetronomeClass> {
  static int tempo = 100;

  //Initial Style
  Color _bkgColor = Colors.redAccent;
  Color _txtColor = Colors.white;
  final _biggerFont = const TextStyle(fontSize: 75.0);

  bool _isPlaying = false;

  Metronome _metronome =
  new Metronome.epoch(new Duration(milliseconds: (60000 / tempo).round()));
  StreamSubscription<DateTime> _subscription;

  void _play() {
    setState(() {
      if (_isPlaying) {
        _subscription.cancel();
        _isPlaying = false;

        _bkgColor = Colors.redAccent;
      } else {
        _subscription =
            _metronome.listen((d) => SystemSound.play(SystemSoundType.click));
        _isPlaying = true;

        _bkgColor = Colors.greenAccent;
      }
    });
  }

  void _increaseTempo(int decrease) {
    if (!((tempo > 299 && decrease < 0) || (tempo < 41 && decrease > 0))) {
      setState(() {
        tempo -= (decrease / 4).ceil();
      });
      _metronome = new Metronome.epoch(
          new Duration(milliseconds: (60000 / tempo).round()));

      if (_isPlaying) {
        _subscription.cancel();
        _subscription =
            _metronome.listen((d) => SystemSound.play(SystemSoundType.click));
      }
    }
  }

  final double barHeight = 50.0;
  @override

  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Metronome',
      home: new Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text('Metronome',
                style: TextStyle(letterSpacing: 1.2,fontSize: 22.0, color: Colors.white,),

              ),),
            backgroundColor: Colors.black38,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),

          ),
        //Red or green depending on the state of playing
          backgroundColor: _bkgColor,
          body: new GestureDetector(
            //Increase or decrease tempo based on swipe direction
            onVerticalDragUpdate: (DragUpdateDetails updateDetails) {
              _increaseTempo((updateDetails.primaryDelta / 6).floor());
            },
            onHorizontalDragUpdate: (DragUpdateDetails updateDetails) {
              _increaseTempo((updateDetails.primaryDelta / 6).floor());
            },

            //SizedBox.expand means the button takes up the entire screen
            child: new SizedBox.expand(
              child: new FlatButton(
                child: new Text(
                  "$tempo",
                  style: TextStyle(fontSize: 75.0,
                  fontWeight: FontWeight.bold),
                ),

                //White
                textColor: _txtColor,

                //Plays or pauses the metronome
                onPressed: () {
                  _play();
                },
              ),
            ),
          )),
    );
  }
}