import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:battery_percentage/global/acts.dart';
import 'package:battery_percentage/main.dart';
import 'package:battery_percentage/screens/battery_status.dart';
import 'package:battery_percentage/screens/ble_access.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/src/provider.dart';

class HomePage extends StatefulWidget {
  String address;
  String email;
  HomePage(
    this.address, this.email);

  @override
  State<HomePage> createState() => _HomePageState();
}

String? cAddress;

class _HomePageState extends State<HomePage> {
  BluetoothConnection? connection;

  String dialog = '';
  bool progress = true;
  bool reconn = false;
  // failed() {}
  connecting() {
    //   if (progress) {
    //     con();
    //   }
    Timer(Duration(seconds: 1), () {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                height: 100,
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      CircularProgressIndicator(),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Connecting',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      // if (reconn)
                      //   ElevatedButton(
                      //       onPressed: () {
                      //         Navigator.pop(context);

                      //         connecting();
                      //       },
                      //       child: Text('Reconnect'))
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }

  espConnect() async {
    Timer(Duration(seconds: 3), () async {
      try {
        connection = await connect(connection, widget.address);
        if (connection != null) {
          cAddress = widget.address;
          Navigator.pop(context);
          upDateBattery();
        } else {
          setState(() {
            Navigator.pop(context);

            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Error occured while connecting'),
                      content: Text("Connection failed. Please retry"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Reconnect"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            connecting();
                            espConnect();
                          },
                        ),
                      ],
                    ));
          });
        }
      } catch (e) {}
    });
  }

  upDateBattery() {
    if (!context.read<Battery>().listening) {
      connection!.input!.listen((Uint8List data) {
        print(ascii.decode(data));
        // Timer(Duration(seconds: 5), () {
        //   if (!ascii
        //       .decode(data)
        //       .toString()
        //       .contains('%')) {
        //     print('It\'s garbage');

        //   } else {
        context.read<Battery>().increment(ascii.decode(data));
        //   }
        // });
        // print(percent);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // connecting();
    connecting();
    espConnect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<Battery>().stopIncrement();
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.only(left: 30, bottom: 50),
                    child: Text(
                      "Welcome Back",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      bigButton(
                          context,
                          Icon(
                            Icons.bluetooth,
                            size: 55,
                            color: Colors.white,
                          ),
                          'Ble Access', ontap: () {
                        if (connection != null && connection!.isConnected) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => BleAccess(
                                    connection!, widget.email
                                  )));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Device not connected')));
                        }
                      }),
                      bigButton(
                          context,
                          Icon(
                            Icons.battery_charging_full,
                            size: 55,
                            color: Colors.white,
                          ),
                          'Battery Status', ontap: () {
                        if (connection != null && connection!.isConnected) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  BatteryStatus(connection!)));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Device not connected')));
                        }
                      }),
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
              ],
            )),
      ),
    );
  }

  InkWell bigButton(BuildContext context, icon, text,
      {ontap, double? width, double? height}) {
    width ??= 170;
    height ??= 170;
    return InkWell(
      borderRadius: BorderRadius.circular(35),
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color.fromARGB(69, 120, 181, 255),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(33, 0, 0, 0),
              blurRadius: 15,
              offset: const Offset(0, 1),
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        padding: EdgeInsets.all(15),
        width: width,
        height: height,
        child: Center(
            child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            if (icon != null) icon,
            SizedBox(
              height: 20,
            ),
            Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        )),
      ),
    );
  }
}
