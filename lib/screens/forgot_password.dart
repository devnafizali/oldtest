// ignore_for_file: prefer_const_constructors

import 'package:battery_percentage/data.dart';
import 'package:battery_percentage/global/decorations.dart';
import 'package:battery_percentage/screens/ble_bat_choose.dart';
import 'package:battery_percentage/screens/discovery_page.dart';
import 'package:battery_percentage/screens/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  void validate() async {
    if (formkey.currentState!.validate()) {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      firebaseAuth.sendPasswordResetEmail(email: username.text).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password reset mail has been sent")));
        Navigator.pop(context);
      }).catchError((e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Something went wrong")));
      });
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
                  padding: EdgeInsets.only(top: 100),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Reset Password",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
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
                                    controller: username,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      filled: true,
                                      hintText: 'Enter your email',
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
                              ),
                              SizedBox(height: 30),
                            ],
                          )),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30, right: 30),
                        child: InkWell(
                            onTap: validate,
                            child: Container(
                              decoration: mydecoration(),
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              child: Center(
                                  child: Text(
                                'Reset Password',
                                style: TextStyle(
                                  color: Color.fromRGBO(127, 71, 158, 1),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                            onHover: (event) {}),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Center(
                                  child: Text(
                                'Log in',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),

                                  fontSize: 17,
                                  // fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                          ])
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
