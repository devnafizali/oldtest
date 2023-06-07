import 'dart:async';

import 'package:battery_percentage/data.dart';
import 'package:battery_percentage/global/bluetooth_device_list_entry.dart';
import 'package:battery_percentage/screens/ble_bat_choose.dart';
import 'package:battery_percentage/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../global/decorations.dart';

String? uniUser;

class DiscoveryPage extends StatefulWidget {
  // BluetoothDiscoveryResult
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;
  String user;
  DiscoveryPage(this.user, {this.start = true});

  @override
  _DiscoveryPage createState() => new _DiscoveryPage();
}

class _DiscoveryPage extends State<DiscoveryPage> {
  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)
  List<String> deviceList = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController value1Controller = TextEditingController();
  // setDeviceList() async {
  //   List<String>? newList = await getList('espList');
  //   if (newList != null) {
  //     deviceList = newList;
  //   }
  // }

  TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery

    super.dispose();
  }

  bondingDialog(text, load, {bool? dismiss}) {
    dismiss ??= false;
    showDialog(
        barrierDismissible: dismiss,
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
                    load ? CircularProgressIndicator() : Container(),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      text,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
  }

  connectTo(address) async {
    BluetoothDevice device = BluetoothDevice(address: address);

    try {
      bool bonded = false;
      if (device.isBonded) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage(device.address, widget.user)));
      } else {
        print('Bonding with ${device.address}');
        bondingDialog("Bonding", true);
        try {
          bonded = (await FlutterBluetoothSerial.instance
              .bondDeviceAtAddress(device.address))!;
        } on Exception catch (e) {
          bonded = true;
          Navigator.pop(context);
          // bondingDialog("Bonding failed", false);
        }
        if (bonded) {
          if (!deviceList.contains(device.address)) {
            deviceList.add(device.address.toString());
            saveList('espList', deviceList);
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(device.address , widget.user)));
        } else {
          Navigator.pop(context);
          bondingDialog("Bonding failed", false);
        }

        print(
            'Bonding with ${device.address} has ${bonded ? 'succeed' : 'failed'}.');
      }
    } catch (ex) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context2) {
          return AlertDialog(
            title: const Text('Error occured while Connecting'),
            content: Text("${ex.toString()}"),
            actions: <Widget>[
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context2).pop();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<List> getdevices() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    List? esps;
    QuerySnapshot snapshot = await firebaseFirestore
        .collection('users')
        .where('email', isEqualTo: widget.user)
        .get();
    snapshot.docs.forEach((element) {
      Map data = element.data() as Map;
      esps = data['esps'];
    });

    return esps!;
  }

  void setdevice(currentList) async {
    bondingDialog("Please wait", true);
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    List? esps;
    firebaseFirestore
        .collection('users')
        .doc(widget.user)
        .update({'esps': currentList}).then((value) {
      Navigator.pop(context);
    });
  }

  removeDevice(list) {
    bondingDialog("Deleting", true);
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    List? esps;
    firebaseFirestore
        .collection('users')
        .doc(widget.user)
        .update({'esps': list}).then((value) {
      Navigator.pop(context);
      setState(() {});
    });
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
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Your Devices',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  FutureBuilder(
                      future: getdevices(),
                      builder: (context, AsyncSnapshot<List> snapshot) {
                        uniUser = widget.user;
                        return Column(
                          children: [
                            snapshot.data == null
                                ? Column(
                                    children: [
                                      Center(
                                        child: Text('No Devices'),
                                      )
                                    ],
                                  )
                                : Column(
                                    children: [
                                      for (String device in snapshot.data!)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                              child: InkWell(
                                            onTap: () async {
                                              connectTo(device);
                                            },
                                            child: Container(
                                              height: 70,
                                              width: double.infinity,
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color.fromARGB(
                                                        33, 0, 0, 0),
                                                    blurRadius: 15,
                                                    offset: const Offset(0, 1),
                                                    blurStyle: BlurStyle.outer,
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.bluetooth),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Device ${snapshot.data!.indexOf(device) + 1}',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            ' ${device}',
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      164,
                                                                      164,
                                                                      164),
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        icon: Icon(Icons.edit),
                                                        onPressed: (() {
                                                          newMethod(
                                                              snapshot.data!,
                                                              isEdit: true,
                                                              index: snapshot
                                                                  .data!
                                                                  .indexOf(
                                                                      device),
                                                              mac: device);
                                                        }),
                                                      ),
                                                      IconButton(
                                                        icon:
                                                            Icon(Icons.delete),
                                                        onPressed: (() {
                                                          List mList = [];
                                                          for (var element
                                                              in snapshot
                                                                  .data!) {
                                                            if (device !=
                                                                element) {
                                                              mList
                                                                  .add(element);
                                                            }
                                                          }
                                                          removeDevice(mList);
                                                        }),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )),
                                        ),
                                    ],
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                child: Container(
                                    // padding: EdgeInsets.fromLTRB(20, 7, 20, 7),
                                    height: 40,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(127, 71, 158, 1),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Add Device",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                                onTap: () {
                                  newMethod(snapshot.data!);
                                },
                              ),
                            )
                          ],
                        );
                      }),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 140,
                    child: InkWell(
                        onTap: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Loginpage()),
                              (route) => false);
                        },
                        child: Container(
                          decoration: mydecoration(),
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          child: Center(
                              child: Text(
                            'Log out',
                            style: TextStyle(
                              color: Color.fromRGBO(127, 71, 158, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ),
                        onHover: (event) {}),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> newMethod(List list, {bool? isEdit, String? mac, index}) {
    isEdit ??= false;
    if (isEdit) {
      value1Controller.text = mac!;
    }
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
                            hintText: isEdit!
                                ? "Edit Mac address"
                                : "Enter mac address",
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
                                "Done",
                                style: TextStyle(color: Colors.white),
                              )),
                          onTap: () {
                            if (value1Controller.text.isNotEmpty) {
                              Navigator.pop(context);
                              setState(() {
                                // list.add(value1Controller.text);
                                if (isEdit!) {
                                  list[index] = value1Controller.text;
                                  setdevice(list);
                                } else {
                                  setdevice([...list, value1Controller.text]);
                                }
                                value1Controller.text = "";
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
