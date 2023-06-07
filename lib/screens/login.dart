// ignore_for_file: prefer_const_constructors

import 'package:battery_percentage/data.dart';
import 'package:battery_percentage/global/decorations.dart';
import 'package:battery_percentage/screens/ble_bat_choose.dart';
import 'package:battery_percentage/screens/discovery_page.dart';
import 'package:battery_percentage/screens/forgot_password.dart';
import 'package:battery_percentage/screens/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  void validate() async {
    if (formkey.currentState!.validate()) {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      firebaseAuth
          .signInWithEmailAndPassword(
              email: username.text.toString(),
              password: password.text.toString())
          .then((value) {
        if (value.user != null) {
          print("object");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => DiscoveryPage(username.text)),
              (route) => false);
        } else {}
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
                                child: Container(
                                  width: 300,
                                  child: TextFormField(
                                    controller: password,
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
                  child: Column(
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
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUp()));
                              },
                              child: Center(
                                  child: Text(
                                'Sign up here',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),

                                  fontSize: 17,
                                  // fontWeight: FontWeight.bold,
                                ),
                              )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ForgotPassword()));
                              },
                              child: Center(
                                  child: Text(
                                'Forgot password?',
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
