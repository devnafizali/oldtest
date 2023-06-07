import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../global/decorations.dart';
import 'discovery_page.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    TextEditingController passwordController = TextEditingController();
    GlobalKey<FormState> formkey = GlobalKey<FormState>();

    void validate() async {
      if (formkey.currentState!.validate()) {
        FirebaseAuth firebaseAuth = FirebaseAuth.instance;
        firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((value) {
          FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
          firebaseFirestore.collection('users').doc(emailController.text).set({
            "email": emailController.text,
            "esps": [],
            "bles": [{}]
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => DiscoveryPage(emailController.text)),
              (route) => false);
        });
      }
    }

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
                      "Sign up",
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
                                    controller: emailController,
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
                                    controller: passwordController,
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
                                'Sign up',
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
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                            child: Text(
                          'Login here',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),

                            fontSize: 17,
                            // fontWeight: FontWeight.bold,
                          ),
                        )),
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
