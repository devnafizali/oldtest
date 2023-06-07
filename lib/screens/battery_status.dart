import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:battery_percentage/global/decorations.dart';
import 'package:battery_percentage/global/disposeable_widget.dart';
import 'package:battery_percentage/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class BatteryStatus extends StatefulWidget {
  BluetoothConnection connection;
  BatteryStatus(this.connection);

  @override
  State<BatteryStatus> createState() => _BatteryStatusState();
}

class _BatteryStatusState extends State<BatteryStatus> with DisposableWidget {
  String percent = " !%";
  // StreamSubscription? streamSubscription;
  Stream<Uint8List>? stream;
  getValues() async {
    // String a = await widget.connection.output.allSent;
    // print(a);

    print('000000');
    // try {
    //   streamSubscription = widget.connection.input!.listen((Uint8List data) {
    //     print('Data incoming: ${ascii.decode(data)}');
    //     setState(() {
    //       percent = ascii.decode(data);
    //       print(percent);
    //     });
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var loaded = false;

  @override
  void initState() {
    getValues();
    Timer(Duration(seconds: 3), () {
      setLoaded();
    });
    super.initState();
  }

  setLoaded() {
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 0.8],
                colors: [
                  Color.fromRGBO(127, 71, 158, 1),
                  Color.fromRGBO(80, 151, 203, 1),
                ],
              ),
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Container(
                    height: 350,
                    width: 350,
                    decoration: mydecoration(),
                    // padding: EdgeInsets.symmetric(vertical: 200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Battery Status",
                          style: TextStyle(
                              fontSize: 35,
                              color: Color.fromRGBO(127, 71, 158, 1)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            child: CircularStepProgressIndicator(
                              totalSteps: 100,
                              currentStep: double.parse((Provider.of<Battery>(
                                          context,
                                          listen: true)
                                      .getBatteryPercent()))
                                  .round(),
                              stepSize: 10,
                              selectedColor: Color.fromARGB(255, 205, 113, 255),
                              unselectedColor: Colors.grey[200],

                              padding: 0,
                              width: 150,
                              height: 150,
                              selectedStepSize: 15,
                              roundedCap: (_, __) => true,
                              child: Center(
                                child: loaded
                                    ? Text(
                                        Provider.of<Battery>(context,
                                                listen: true)
                                            .getBatteryPercent(),
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 131, 255, 255)),
                                      )
                                    : CircularProgressIndicator(),
                              ),
                              // gradientColor: LinearGradient(colors: [
                              //   Color.fromARGB(255, 255, 255, 255),
                              //   Colors.purple
                              // ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }
}
