import 'dart:async';
import 'dart:convert';

import 'package:battery_percentage/data.dart';
import 'package:battery_percentage/global/acts.dart';
import 'package:battery_percentage/global/device_list.dart';
import 'package:battery_percentage/global/device_widget.dart';
import 'package:battery_percentage/screens/discovery_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BleAccess extends StatefulWidget {
  BluetoothConnection connection;
  String email;
  BleAccess(this.connection, this.email);

  @override
  State<BleAccess> createState() => _BleAccessState();
}

class _BleAccessState extends State<BleAccess> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController value1Controller = TextEditingController();
  TextEditingController value2Controller = TextEditingController();
  BluetoothConnection? _connection;
  List<Device> deviceList = [
    // Device(value1: 'device name', value2: 'connected'),
  ];
  bool dev = false;
  int i = 0;
  int? length;
  BluetoothDevice? _device;
  BluetoothState? state;
  bool isUploading = false;

  updateInEsp() async {
    if (i < deviceList.length) {
      setState(() {
        print("Setting true");

        isUploading = true;
      });
      Timer(Duration(milliseconds: 5000), () {
        if (_connection!.isConnected) {
          try {
            _connection!.output.add(ascii.encode('${deviceList[i].value2}'));
            updateInEsp();
            i++;
          } catch (e) {
            print(e);
          }
          setState(() {
            print("Setting false");
            isUploading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Device is not connected. Please connect again and retry')));
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DiscoveryPage(uniUser!)),
              (route) => false);
        }
      });
    } else {
      setState(() {
        isUploading = false;
      });
    }
  }

  setList() async {
    print(widget.email);
    length = await getLength('length');
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.email)
        .get();
    Map data = snapshot.data() as Map;
    List bles = data['bles'];
    for (Map ble in bles) {
      setState(() {
        deviceList.add(Device(value1: ble['name'], value2: ble['address']));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _connection = widget.connection;
    setList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              children: [
                Container(
                  height: 600,
                  margin: EdgeInsets.fromLTRB(10, 80, 10, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 20, 10, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.grey),
                          ),
                        ),
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 10),
                        child: Text(
                          "Ble Devices",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        height: 450,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Column(
                              children: [
                                if (deviceList.isNotEmpty)
                                  for (Device device in deviceList)
                                    DeviceWidget(
                                      device: device,
                                      onDeletePressed: () {
                                        int index = deviceList.indexOf(device);
                                        setState(() {
                                          List mapList = [];
                                          for (Device device in deviceList) {
                                            mapList.add({
                                              "name": device.value1,
                                              "address": device.value2
                                            });
                                          }
                                          mapList.removeAt(index);
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget.email)
                                              .update({
                                            "bles": [...mapList]
                                          }).then((value) {
                                            setState(() {
                                              deviceList.removeAt(index);
                                            });
                                          });
                                        });
                                      },
                                    )
                                else
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('No Devices'),
                                  ),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  child: Container(
                                    width: 180,
                                    padding: EdgeInsets.fromLTRB(20, 7, 0, 7),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(110, 128, 71, 158),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      children: [
                                        new Icon(Icons.add,
                                            size: 35, color: Colors.white),
                                        Text(
                                          "Add Device",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    if (deviceList.length < 6) {
                                      newMethod(context);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  decoration: BoxDecoration(
                                    color: !isUploading
                                        ? Color.fromRGBO(127, 71, 158, 1)
                                        : Color.fromARGB(255, 138, 120, 148),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    !isUploading ? "Update" : "Uploading",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                              onTap: () {
                                if (!isUploading) {
                                  i = 0;
                                  updateInEsp();
                                }
                              },
                            ),
                            InkWell(
                              child: Container(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(127, 71, 158, 1),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    "Reset",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )),
                              onTap: () {
                                setState(() {
                                  if (_connection != null &&
                                      _connection!.isConnected) {
                                    _connection!.output
                                        .add(ascii.encode('reset'));
                                    deviceList.clear();
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.email)
                                        .update({"bles": []});
                                    for (var i = 1;
                                        i <= deviceList.length;
                                        i++) {
                                      deleteData('$i');
                                    }
                                    deleteData('length');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Device is not connected. Please connect and try again')));
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DiscoveryPage(uniUser!)),
                                        (route) => false);
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }

  Future<dynamic> newMethod(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            backgroundColor: Colors.white,
            content: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: value1Controller,
                          decoration: InputDecoration(
                            icon: Icon(Icons.device_unknown,
                                size: 20, color: Colors.black),
                            hintText: "Device name",
                            hintStyle:
                                TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: value2Controller,
                          decoration: InputDecoration(
                            icon: Icon(Icons.device_unknown,
                                size: 20, color: Colors.black),
                            hintText: "Mac address",
                            hintStyle:
                                TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Container(
                              padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(127, 71, 158, 1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                "Add",
                                style: TextStyle(color: Colors.white),
                              )),
                          onTap: () {
                            if (value1Controller.text.isNotEmpty &&
                                value2Controller.text.isNotEmpty) {
                              List mapList = [];
                              for (Device device in deviceList) {
                                mapList.add({
                                  "name": device.value1,
                                  "address": device.value2
                                });
                              }
                              setState(() {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(widget.email)
                                    .update({
                                  "bles": [
                                    ...mapList,
                                    {
                                      "name": value1Controller.text,
                                      "address": value2Controller.text
                                    }
                                  ]
                                }).then((value) {
                                  Navigator.pop(context);
                                  setState(() {
                                    deviceList = [
                                      ...deviceList,
                                      Device(
                                          value1: value1Controller.text,
                                          value2: value2Controller.text)
                                    ];
                                  });
                                  value1Controller.text = "";
                                  value2Controller.text = "";
                                });
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
