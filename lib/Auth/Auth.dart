import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Dashboard/Dashboard.dart';

class Authpage extends StatefulWidget {
  const Authpage({super.key});

  @override
  State<Authpage> createState() => _AuthpageState();
}

class _AuthpageState extends State<Authpage> {
  TextEditingController mobile = TextEditingController();
  TextEditingController otp = TextEditingController();
  bool vericationcompleted = false;
  var verificationid = '';
  bool loading = false;
  verifymonile() {
    if (mobile.text.trim().length == 10) {
      setState(() {
        loading = true;
      });
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91${mobile.text}",
        verificationCompleted: (phoneAuthCredential) {},
        verificationFailed: (error) {
          setState(() {
            vericationcompleted = false;
            loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Please enter valid input",
              ),
              duration: Duration(seconds: 3),
            ),
          );
          print("Enter is eroor----$error");
        },
        codeSent: (verificationId, forceResendingToken) {
          setState(() {
            vericationcompleted = true;
            verificationid = verificationId;
            loading = false;
          });
          print("Enter is success");
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter valid input",
          ),
          duration: Duration(seconds: 3),
        ),
      );
      setState(() {
        vericationcompleted = false;
        loading = false;
      });
    }

    print("Enter---  +91${mobile.text}");
  }

  verifyOTP() async {
    if (otp.text.trim().length == 6) {
      try {
        setState(() {
          loading = true;
        });
        final cred = PhoneAuthProvider.credential(
            verificationId: verificationid, smsCode: otp.text);
        await FirebaseAuth.instance.signInWithCredential(cred);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Logged in successfully",
            ),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
          (Route<dynamic> route) => false,
        );
        setState(() {
          loading = false;
        });
      } catch (e) {
        setState(() {
          loading = false;
        });
      }
    } else {
      setState(() {
        // vericationcompleted = false;
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter valid input",
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: const Color.fromARGB(255, 10, 60, 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35))),
                        alignment: AlignmentDirectional.bottomEnd,
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Phone Number",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: mobile,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      keyboardType: TextInputType.phone,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        // hintText: 'Phone number',
                                        // hintStyle: const TextStyle(
                                        //     color: Colors.white),
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            255, 20, 20, 62),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          setState(() {
                                            vericationcompleted = false;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              vericationcompleted
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "OTP",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextFormField(
                                            controller: otp,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  6),
                                            ],
                                            keyboardType: TextInputType.phone,
                                            style: const TextStyle(
                                                color: Colors.white),
                                            decoration: InputDecoration(
                                              // hintText: 'OTP',
                                              // hintStyle: const TextStyle(
                                              //     color: Colors.white),
                                              filled: true,
                                              fillColor: const Color.fromARGB(
                                                  255, 20, 20, 62),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.blue),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () {
                                  vericationcompleted
                                      ? verifyOTP()
                                      : verifymonile();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.grey[800], // Background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 15),
                                  child: loading
                                      ? Container(
                                          height: 25,
                                          width: 25,
                                          child:
                                              const CircularProgressIndicator(
                                            color: Colors.white,
                                          ))
                                      : Text(
                                          vericationcompleted
                                              ? 'LOGIN'
                                              : "Send OTP",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 140,
                  ),
                  child: Container(
                    height: 40,
                    width: 120,
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: const Center(
                        child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
