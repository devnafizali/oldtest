// ignore_for_file: prefer_const_constructors

import 'package:battery_percentage/data.dart';
import 'package:battery_percentage/global/decorations.dart';
import 'package:battery_percentage/screens/ble_bat_choose.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void validate() {
    if (formkey.currentState!.validate()) {
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  void initState() {
    // saveList('key', list)
    // TODO: implement initState
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 80, 0, 60),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                    child: SingleChildScrollView(
                      child: Form(
                          key: formkey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(33, 0, 0, 0),
                                      blurRadius: 25,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      filled: true,
                                      hintText: 'Enter your username',
                                      fillColor:
                                          Color.fromARGB(69, 120, 181, 255),
                                      hintStyle: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          15.0, 15.0, 15.0, 0.0),
                                      prefixIcon: const Icon(
                                        Icons.face,
                                        color: Colors.white,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Required";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 28,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(33, 0, 0, 0),
                                      blurRadius: 25,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.white),
                                    obscureText: true,
                                    // ignore: prefer_const_constructors
                                    decoration: InputDecoration(
                                      filled: true,
                                      hintText: 'Enter your password',
                                      fillColor:
                                          Color.fromARGB(69, 120, 181, 255),
                                      hintStyle: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: EdgeInsets.fromLTRB(
                                          15.0, 15.0, 15.0, 0.0),
                                      prefixIcon: const Icon(
                                        Icons.vpn_key,
                                        color: Colors.white,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Required";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                            ],
                          )),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 140,
                        child: InkWell(
                            onTap: validate,
                            child: Container(
                              decoration: mydecoration(),
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              child: Center(
                                  child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Color.fromRGBO(127, 71, 158, 1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                            onHover: (event) {}),
                      ),
                      Container(
                        width: 140,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: mydecoration(),
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            child: Center(
                                child: Text(
                              'Update',
                              style: TextStyle(
                                color: Color.fromRGBO(127, 71, 158, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
