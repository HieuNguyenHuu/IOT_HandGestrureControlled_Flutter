import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import 'sprite.dart';

import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TeslaCar(),
    );
  }
}

Color greyDark = Color(0xff383B49);
Color greyMedium = Color(0xff4B4D5B);
Color greyLight = Color(0xff6D707C);
Color lighTitle = Color(0xff797C89);

class TeslaCar extends StatefulWidget {
  @override
  _TeslaCarState createState() => _TeslaCarState();
}

final dbref = FirebaseDatabase.instance.reference();

String up, down, left, right, engine, lighting;

int acce = 0;

class _TeslaCarState extends State<TeslaCar> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _switchCtrl;
  Animation<int> anim;

  double get w => MediaQuery.of(context).size.width;
  double get h => MediaQuery.of(context).size.height;

  double chx = 0;

  /* void setdatabaserealtime() {
    dbref.child("IOT").set({
      'lighting': 'on',
      'accelerator': acce,
      'engine': 'off',
      'left': 'false',
      'right': 'false',
      'up': 'false',
      'down': 'false'
    });
  }*/

  /*void stream() {
    /*dbref.once().then((value) {
      //print(value.value['IOT'][].toString());
      //Map map = value.value.data.snapshot.value;
      engine = value.value['IOT']['engine'].toString();
      lighting = value.value['IOT']['lighting'].toString();
      up = value.value['IOT']['up'].toString();
      down = value.value['IOT']['down'].toString();
      left = value.value['IOT']['left'].toString();
      right = value.value['IOT']['right'].toString();
      acce = int.parse(value.value['IOT']['accelerator'].toString());
    });*/
    /*StreamBuilder(
      stream: dbref.onValue,
      builder: (context, snap) {
        /*if (snap.hasData &&
            !snap.hasError &&
            snap.data.snapshot.value != null) {*/
        Map map = snap.data.snapshot.value;
        engine = map['IOT']['engine'].toString();
        lighting = map['IOT']['lighting'].toString();
        up = map['IOT']['up'].toString();
        down = map['IOT']['down'].toString();
        left = map['IOT']['left'].toString();
        right = map['IOT']['right'].toString();
        acce = int.parse(map['IOT']['accelerator'].toString());
        print(map['IOT']['engine'].toString());
        //x}
      },
    );*/
  }*/

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600))
          ..addListener(() {
            setState(() {});
          });
    _switchCtrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 6000))
          ..addListener(() {
            setState(() {});
          });
    anim = StepTween(begin: 0, end: 49).animate(_switchCtrl);
    //stream();
    //setdatabaserealtime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyLight,
      body: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xff2D3436), Color(0xff000000)],
          )),
          child: Stack(
            children: [
              TopLayout(
                ctrl: _controller.value,
              ),
              TopLayoutBg(
                ctrl: _controller.value,
                onTap: _toggle,
              ),
              Positioned(
                top: (h * 0.18 + 40),
                right: -w * _controller.value,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 240),
                  opacity: _controller.value > 0.2 ? 0 : 1,
                  child: Container(
                    width: w * 0.64,
                    height: h - (h * 0.3 + 20),
                    alignment: Alignment.center,
                    child: Rightlayout(
                      ctrl: _controller.value,
                    ),
                  ),
                ),
              ),
              /*SwitchButton(
                ctrl: _controller.value,
                anim: anim.value.toDouble(),
                chx: chx,
                onTap: () {
                  if (_switchCtrl.isAnimating) {
                    _switchCtrl.reset();
                    setState(() {
                      chx = 0;
                    });
                  } else {
                    _switchCtrl.repeat();
                    setState(() {
                      chx = 1;
                    });
                  }
                },
              ),*/
              Positioned(
                top: h * 0.14 + h * 0.07 * (1 - _controller.value) + 20,
                left: -w * 0.43 * (1 - _controller.value),
                child: Container(
                  width: w,
                  height: h,
                  child: Stack(
                    children: [
                      ArrowUp(
                        isLeft: false,
                        isTop: false,
                        ctrl: _controller.value,
                      ),
                      ArrowDown(
                        isLeft: false,
                        isTop: false,
                        ctrl: _controller.value,
                      ),
                      Opacity(
                        opacity: 0.9,
                        child: Transform.rotate(
                          angle: 0,
                          child: Container(
                            width: w,
                            height: h - (h * 0.3 + 20),
                            padding: EdgeInsets.all(
                                10 + 10 * (1 - _controller.value)),
                            child: Image.asset(
                              "assets/images/tesla.png",
                            ),
                          ),
                        ),
                      ),
                      Dock(
                        isLeft: true,
                        isTop: false,
                        ctrl: _controller.value,
                      ),
                      Dock(
                        isLeft: true,
                        isTop: true,
                        ctrl: _controller.value,
                      ),
                      Dock(
                        isLeft: false,
                        isTop: true,
                        ctrl: _controller.value,
                      ),
                      Dock(
                        isLeft: false,
                        isTop: false,
                        ctrl: _controller.value,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _controller.value += details.primaryDelta / w;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    _controller.fling(velocity: _controller.value < 0.5 ? -1.0 : 1.0);
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;

    _controller.fling(velocity: isOpen ? -1 : 1);
  }
}

class Rightlayout extends StatefulWidget {
  final double ctrl;

  const Rightlayout({Key key, this.ctrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RightlayoutState(ctrl);
}

class RightlayoutState extends State<Rightlayout> {
  double ctrl;

  bool lightingchek = false;
  bool acceleratorcheck = false;
  bool enginecheck = false;

  int acc;

  RightlayoutState(this.ctrl);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Wrap(
      spacing: w * 0.06,
      runSpacing: w * 0.06,
      alignment: WrapAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              if (enginecheck) {
                if (lightingchek) {
                  dbref.child("IOT").update({'lighting': 'off'});
                  lightingchek = false;
                } else {
                  dbref.child("IOT").update({'lighting': 'on'});
                  lightingchek = true;
                }
              } else {
                dbref.child("IOT").update({'lighting': 'off'});
                lightingchek = false;
              }
            });
          },
          child: Container(
            width: w * 0.6,
            height: h * 0.15,
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder(
                    stream: dbref.onValue,
                    builder: (context, snap) {
                      if (snap.hasData &&
                          !snap.hasError &&
                          snap.data.snapshot.value != null) {
                        Map map = snap.data.snapshot.value;
                        //print(map['IOT']['engine'].toString());
                        if (map['IOT']['engine'].toString() == "on") {
                          if (map['IOT']['lighting'].toString() == "on") {
                            lightingchek = true;
                          } else
                            lightingchek = false;
                        } else {
                          dbref.child("IOT").update({'lighting': 'off'});
                          lightingchek = false;
                        }
                        return Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/images/car-light-high.png",
                            color: lightingchek ? Colors.black : Colors.white,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                lightingchek ? Colors.yellow[400] : greyMedium,
                          ),
                        );
                      }
                    }),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 90,
                  child: Text(
                    "Lighting Controller",
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StreamBuilder(
                    stream: dbref.onValue,
                    builder: (context, snap) {
                      if (snap.hasData &&
                          !snap.hasError &&
                          snap.data.snapshot.value != null) {
                        Map map = snap.data.snapshot.value;
                        //print(map['IOT']['engine'].toString());
                        return Text(
                          //lightingchek ? "ON" : "OFF",
                          //lighting.toString(),
                          map['IOT']['lighting'].toString(),
                          softWrap: true,
                          style: TextStyle(
                            color: lightingchek
                                ? Colors.yellow[400]
                                : Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Text(
                          lightingchek ? "ON" : "OFF",
                          //lighting.toString(),
                          softWrap: true,
                          style: TextStyle(
                            color: lightingchek
                                ? Colors.yellow[400]
                                : Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    }),
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xff7670EE),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {});
          },
          child: Container(
            width: w * 0.6,
            height: h * 0.15,
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(10),
                  child: Image.asset(
                    "assets/images/axis.png",
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 90,
                  child: Text(
                    "Accelerator Sensor",
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StreamBuilder(
                    stream: dbref.onValue,
                    builder: (context, snap) {
                      if (snap.hasData &&
                          !snap.hasError &&
                          snap.data.snapshot.value != null) {
                        Map map = snap.data.snapshot.value;
                        if (map['IOT']['engine'].toString() == "off") {
                          dbref.child("IOT").update({'acceleratorx': 0});
                          dbref.child("IOT").update({'acceleratory': 0});
                        }
                        return Column(
                          verticalDirection: VerticalDirection.down,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "x " + map['IOT']['acceleratorx'].toString(),
                              softWrap: true,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "y " + map['IOT']['acceleratory'].toString(),
                              softWrap: true,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Text(
                          acce.toString(),
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    }),
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xff2EAEFB),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if (enginecheck) {
                dbref.child("IOT").update({'engine': 'off'});
                enginecheck = false;
              } else {
                dbref.child("IOT").update({'engine': 'on'});
                enginecheck = true;
              }
            });
          },
          child: Container(
            width: w * 0.6,
            height: h * 0.15,
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder(
                    stream: dbref.onValue,
                    builder: (context, snap) {
                      if (snap.hasData &&
                          !snap.hasError &&
                          snap.data.snapshot.value != null) {
                        Map map = snap.data.snapshot.value;
                        if (map['IOT']['engine'].toString() == "on") {
                          enginecheck = true;
                        } else
                          enginecheck = false;

                        return Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/images/power.png",
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: enginecheck ? Colors.blue : Colors.red[400],
                          ),
                        );
                      }
                    }),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 90,
                  child: Text(
                    "Engine Controller",
                    softWrap: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StreamBuilder(
                    stream: dbref.onValue,
                    builder: (context, snap) {
                      if (snap.hasData &&
                          !snap.hasError &&
                          snap.data.snapshot.value != null) {
                        Map map = snap.data.snapshot.value;
                        return Text(
                          //enginecheck ? "ON" : "OFF",
                          map['IOT']['engine'].toString(),
                          softWrap: true,
                          style: TextStyle(
                            color: enginecheck
                                ? Colors.blue[300]
                                : Colors.red[300],
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Text(
                          enginecheck ? "ON" : "OFF",
                          //lighting.toString(),
                          softWrap: true,
                          style: TextStyle(
                            color:
                                enginecheck ? Colors.yellow[400] : Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    }),
              ],
            ),
            decoration: BoxDecoration(
              color: greyLight,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}

class ArrowUp extends StatefulWidget {
  final double top;
  final double left;
  final double angle;
  final bool isLeft;
  final bool isTop;
  final bool isBotLeft;
  final double ctrl;

  const ArrowUp({
    Key key,
    this.top,
    this.left,
    this.angle,
    this.isLeft,
    this.isTop,
    this.isBotLeft,
    this.ctrl,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      ArrowUpState(top, left, angle, isLeft, isTop, isBotLeft, ctrl);
}

class ArrowUpState extends State<ArrowUp> {
  double top;
  double left;
  double angle;
  bool isLeft;
  bool isTop;
  bool isBotLeft;
  double ctrl;

  bool upcheck = false;

  ArrowUpState(this.top, this.left, this.angle, this.isLeft, this.isTop,
      isBotLeft, this.ctrl);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Positioned(
      top: -280,
      left: -70,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 240),
        opacity: widget.ctrl > 0.8 ? 1 : 0,
        child: Container(
          width: 500,
          height: 500,
          child: StreamBuilder(
            stream: dbref.onValue,
            builder: (context, snap) {
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data.snapshot.value != null) {
                Map map = snap.data.snapshot.value;
                if (map['IOT']['up'].toString() == "true")
                  upcheck = true;
                else
                  upcheck = false;
                return Stack(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 500,
                          height: 500,
                          padding: EdgeInsets.all(10),
                          child: Transform.rotate(
                            angle: pi / 2 * 3,
                            child: FlareActor(
                              "assets/arrow.flr",
                              animation: upcheck ? "animation" : "open",
                              sizeFromArtboard: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ArrowDown extends StatefulWidget {
  final double top;
  final double left;
  final double angle;
  final bool isLeft;
  final bool isTop;
  final bool isBotLeft;
  final double ctrl;

  const ArrowDown({
    Key key,
    this.top,
    this.left,
    this.angle,
    this.isLeft,
    this.isTop,
    this.isBotLeft,
    this.ctrl,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      ArrowDownState(top, left, angle, isLeft, isTop, isBotLeft, ctrl);
}

class ArrowDownState extends State<ArrowDown> {
  double top;
  double left;
  double angle;
  bool isLeft;
  bool isTop;
  bool isBotLeft;
  double ctrl;

  bool downcheck = false;

  ArrowDownState(this.top, this.left, this.angle, this.isLeft, this.isTop,
      isBotLeft, this.ctrl);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Positioned(
      top: 250,
      left: -70,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 240),
        opacity: widget.ctrl > 0.8 ? 1 : 0,
        child: Container(
          width: 500,
          height: 500,
          child: StreamBuilder(
            stream: dbref.onValue,
            builder: (context, snap) {
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data.snapshot.value != null) {
                Map map = snap.data.snapshot.value;
                if (map['IOT']['down'].toString() == "true")
                  downcheck = true;
                else
                  downcheck = false;
                return Stack(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 500,
                          height: 500,
                          padding: EdgeInsets.all(10),
                          child: Transform.rotate(
                            angle: pi / 2,
                            child: FlareActor(
                              "assets/arrow.flr",
                              animation: downcheck ? "animation" : "open",
                              sizeFromArtboard: true,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

List<int> DockStates = [0, 1, 2, 3];

class Dock extends StatefulWidget {
  final double top;
  final double left;
  final double angle;
  final CustomPainter painter;
  final bool isLeft;
  final bool isTop;
  final bool isBotLeft;
  final double ctrl;

  const Dock({
    Key key,
    this.top,
    this.left,
    this.angle,
    this.painter,
    this.isLeft,
    this.isTop,
    this.isBotLeft,
    this.ctrl,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      DockState(top, left, angle, painter, isLeft, isTop, isBotLeft, ctrl);
}

class DockState extends State<Dock> {
  double top;
  double left;
  double angle;
  CustomPainter painter;
  bool isLeft;
  bool isTop;
  bool isBotLeft;
  double ctrl;

  bool enginecheck = false;
  bool leftcheck = false;
  bool rightcheck = false;
  bool lightingcheck = false;

  DockState(this.top, this.left, this.angle, this.painter, this.isLeft,
      this.isTop, isBotLeft, this.ctrl);

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Positioned(
      top: widget.isTop ? w * 0.02 : w * 0.95,
      left: widget.isLeft ? w * 0.05 : w * 0.67,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 240),
        opacity: widget.ctrl > 0.8 ? 1 : 0,
        child: Container(
          width: w * 0.8,
          height: 100,
          child: StreamBuilder(
              stream: dbref.onValue,
              builder: (context, snap) {
                if (snap.hasData &&
                    !snap.hasError &&
                    snap.data.snapshot.value != null) {
                  Map map = snap.data.snapshot.value;
                  if (map['IOT']['engine'].toString() == "on")
                    enginecheck = true;
                  else
                    enginecheck = false;
                  if (map['IOT']['left'].toString() == "true")
                    leftcheck = true;
                  else
                    leftcheck = false;
                  if (map['IOT']['right'].toString() == "true")
                    rightcheck = true;
                  else
                    rightcheck = false;

                  if (map['IOT']['lighting'].toString() == "on")
                    lightingcheck = true;
                  else
                    lightingcheck = false;

                  return Stack(
                    children: [
                      if ((widget.isLeft) && (!widget.isTop))
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              padding: EdgeInsets.all(10),
                              child: Image.asset(
                                enginecheck
                                    ? "assets/images/playplay.png"
                                    : "assets/images/pausepause.png", //"assets/images/playplay.png"
                                alignment: Alignment.center,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color:
                                    enginecheck ? Colors.blue : Colors.red[400],
                              ),
                            ),
                            Transform.rotate(
                              angle: 0,
                              child: CustomPaint(
                                foregroundPainter: Painter3(),
                                child: Container(
                                  width: (w * 0.2) - 44,
                                  height: 80,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if ((widget.isLeft) && (widget.isTop))
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              padding: EdgeInsets.all(10),
                              child:
                                  /*Image.asset(
                            "assets/images/lock.png",
                            color: Colors.red,
                          ),*/
                                  Transform.rotate(
                                angle: pi,
                                child: FlareActor(
                                  "assets/arrow.flr",
                                  animation: leftcheck ? "animation" : "open",
                                  sizeFromArtboard: true,
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: lighTitle,
                              ),
                            ),
                            Transform.rotate(
                              angle: 0,
                              child: CustomPaint(
                                foregroundPainter: Painter1(),
                                child: Container(
                                  width: (w * 0.2) - 44,
                                  height: 80,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if ((!widget.isLeft) && (widget.isTop))
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: 0,
                              child: CustomPaint(
                                foregroundPainter: Painter2(),
                                child: Container(
                                  width: (w * 0.2) - 44,
                                  height: 80,
                                ),
                              ),
                            ),
                            Container(
                              width: 70,
                              height: 70,
                              padding: EdgeInsets.all(10),
                              child:
                                  /*Image.asset(
                            "assets/images/lock.png",
                            color: Colors.red,
                          ),*/
                                  Transform.rotate(
                                angle: 0,
                                child: FlareActor(
                                  "assets/arrow.flr",
                                  animation: rightcheck ? "animation" : "open",
                                  sizeFromArtboard: true,
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: lighTitle,
                              ),
                            ),
                          ],
                        ),
                      if ((!widget.isLeft) && (!widget.isTop))
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.rotate(
                              angle: 0,
                              child: CustomPaint(
                                foregroundPainter: Painter4(),
                                child: Container(
                                  width: (w * 0.2) - 44,
                                  height: 80,
                                ),
                              ),
                            ),
                            Container(
                              width: 70,
                              height: 70,
                              padding: EdgeInsets.all(10),
                              child: Image.asset(
                                "assets/images/car-light-high.png",
                                color:
                                    lightingcheck ? Colors.black : Colors.white,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: lightingcheck
                                    ? Colors.yellow[400]
                                    : lighTitle,
                              ),
                            ),
                          ],
                        ),

                      /*if (isTop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.rotate(
                      angle: 0,
                      child: CustomPaint(
                        foregroundPainter:
                            isLeft && isTop ? Painter1() : Painter2(),
                        child: Container(
                          width: (w * 0.2) - 44,
                          height: 80,
                        ),
                      ),
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/images/lock.png",
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: lighTitle,
                      ),
                    ),
                  ],
                ),*/
                    ],
                  );
                }
              }),
        ),
      ),
    );
  }
}

class Painter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = lighTitle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Path path = Path()
      ..moveTo(0.25, size.height * 0.25)
      ..lineTo(size.width * 0.35, size.height * 0.25)
      ..lineTo(size.width - 2, size.height * 0.75)
      ..moveTo(size.width, size.height)
      ..moveTo(0, size.height)
      ..moveTo(0, size.height * 0.25)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(Painter1 oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(Painter1 oldDelegate) => false;
}

class Painter3 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = lighTitle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Path path = Path()
      ..moveTo(0.25, size.height * 0.6)
      ..lineTo(size.width * 0.35, size.height * 0.6)
      ..lineTo(size.width - 2, size.height * 0.3)
      ..moveTo(size.width, size.height)
      ..moveTo(0, size.height)
      ..moveTo(0, size.height * 0.25)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(Painter3 oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(Painter3 oldDelegate) => false;
}

class Painter4 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = lighTitle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Path path = Path()
      ..moveTo(size.width, size.height * 0.6)
      ..lineTo(size.width * 0.5, size.height * 0.6)
      ..lineTo(0, size.height * 0.3)
      ..moveTo(size.width, size.height)
      ..moveTo(size.width, size.height)
      ..moveTo(size.width, size.height * 0.25)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(Painter4 oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(Painter4 oldDelegate) => false;
}

class Painter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = lighTitle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Path path = Path()
      ..moveTo(size.width, size.height * 0.25)
      ..lineTo(size.width * 0.65, size.height * 0.25)
      ..lineTo(6, size.height * 0.75)
      ..moveTo(0, size.height)
      ..moveTo(0, size.height)
      ..moveTo(size.width, size.height * 0.25)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(Painter2 oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(Painter2 oldDelegate) => false;
}

class SwitchButton extends StatelessWidget {
  final double ctrl;
  final double anim;
  final Function onTap;
  final double chx;

  const SwitchButton({Key key, this.ctrl, this.anim, this.onTap, this.chx})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Positioned(
      top: (h * 0.18 + 380),
      right: w * 0.15,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 240),
        opacity: ctrl > 0.8 ? 0 : 1,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: w * 0.33,
            height: w * 0.33,
            decoration: BoxDecoration(color: Colors.black),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 240),
                  top: (w * 0.33 - 12) / 2 * (1 - chx),
                  left: 0,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: (1 - chx),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black),
                      width: w * 0.33,
                      child: Text(
                        "Start Engine",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.purple[50],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 240),
                  bottom: (w * 0.33 - 18) / 2 * chx,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: chx,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black),
                      width: w * 0.33,
                      child: Text(
                        "Switch Off",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.lightGreen[100],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                Sprite(
                  frameWidth: w * 0.33,
                  frameHeight: w * 0.33,
                  frame: 50,
                  anim: anim,
                  img: "assets/images/switch.png",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopLayoutBg extends StatelessWidget {
  final double ctrl;
  final Function onTap;

  const TopLayoutBg({Key key, this.ctrl, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Positioned(
      top: -h * 0.15 * (1 - ctrl),
      left: 0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 240),
        opacity: ctrl < 0.8 ? 0 : 1,
        child: Container(
          width: w,
          height: h * 0.15,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(left: 24, right: 24, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    "Car Model X",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(height: 25),
                ],
              ),
              InkWell(
                onTap: onTap,
                child: Container(
                  width: 36,
                  height: 36,
                  child: Transform.rotate(
                    angle: pi,
                    child: Image.asset("assets/images/arrowleft.png"),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: greyMedium,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomLayout extends StatelessWidget {
  final double ctrl;

  const BottomLayout({Key key, this.ctrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Positioned(
      left: 0,
      bottom: -h * 0.12 * ctrl,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 240),
        opacity: ctrl > 0.2 ? 0 : 1,
        child: Container(
          width: w,
          height: h * 0.12,
          padding: EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: greyMedium,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(12),
                child: Image.asset(
                  "assets/images/fan.png",
                  color: greyLight,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: greyMedium,
                  border: Border.all(
                    color: greyLight,
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(12),
                child: Image.asset(
                  "assets/images/power.png",
                  color: greyLight,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: greyMedium,
                  border: Border.all(
                    color: greyLight,
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(12),
                child: Image.asset(
                  "assets/images/lock.png",
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: greyLight,
                  border: Border.all(
                    color: greyLight,
                    width: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopLayout extends StatelessWidget {
  final double ctrl;

  const TopLayout({Key key, this.ctrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Positioned(
      top: 20 + -h * 0.18 * ctrl,
      left: 0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 240),
        opacity: ctrl > 0.2 ? 0 : 1,
        child: Container(
          width: w,
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          height: h * 0.18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      "assets/images/HCMUT_official_logo.png",
                      height: 40,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Car Model X",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(),
                  children: [
                    TextSpan(
                      text: "Author  ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: "Nguyen Huu Anh Hieu",
                      style: TextStyle(
                        color: lighTitle,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Divider(
                height: 3,
                color: lighTitle,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class WrapModel {
  final Color icnColor;
  final String icn;
  final String title;

  WrapModel(this.icnColor, this.icn, this.title);
}

List<WrapModel> wrapItems = [
  WrapModel(Color(0xff7670EE), "assets/images/car-light-high.png", "Lighting"),
  WrapModel(Color(0xff2EAEFB), "assets/images/steering.png", ""),
  WrapModel(Color(0xffFE7C00), "assets/images/nothing.png", ""),
  WrapModel(Color(0xff26D670), "assets/images/nothing.png", ""),
];
