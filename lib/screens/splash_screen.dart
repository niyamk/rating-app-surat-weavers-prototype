/*
import 'dart:developer';

import 'package:surat_weavers_new/library.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

String user = '';
class _SplashScreenState extends State<SplashScreen> {
  String isotp = '';
  Future getUsername() async {
    String? data = await SharedPrefService.getUsername();
    setState(() {
      user = data ?? '';
    });
  }

  Future getOtpCheck() async {
    String? isotpj = await SharedPrefService.getOtpCheck(currentUsername: user);
    setState(() {
      isotp = isotpj ?? '';
    });
  }
String otpVerification = '';
  Future testingOtp()async{
    String? testing = await otpVerificationStatus();
    setState(() {
      otpVerification = testing ?? '';
    });
  }

  @override
  void initState() {
    testingOtp().whenComplete(() {
      log('phoenix testing ===>>> $otpVerification');
    });
    getUsername().whenComplete(
        () => testingOtp().whenComplete(() => Timer(Duration(seconds: 3), () {
              log('user - $user \nisotp - ${otpVerification}');
              if (user != '' && otpVerification == 'done') {
                Get.off(HomeScreen());
                // Get.off( () => PageTransition(HomeScreen()) );
              } else {
                // Get.off(HomeScreen());
                Get.off(GoogleSignInScreen());
              }
            })));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      // color: PhoenixThemeColor(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          'assets/images/newPhoenix.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
*/


import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:surat_weavers_new/auths/google_signIn.dart';
import 'package:surat_weavers_new/auths/sharedPref.dart';
import 'package:surat_weavers_new/main.dart';
import 'package:surat_weavers_new/screens/home_screen.dart';
import 'package:surat_weavers_new/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
String user = '';
class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _textOpacity = 0.0;
  double _fontSize = 2;
  double _containerSize = 100.w;
  double _containerOpacity = 0.0;

  late Animation<double> animation1;
  late AnimationController _controller;


  String isotp = '';
  Future getUsername() async {
    String? data = await SharedPrefService.getUsername();
    setState(() {
      user = data ?? '';
    });
  }

  Future getOtpCheck() async {
    String? isotpj = await SharedPrefService.getOtpCheck(currentUsername: user);
    setState(() {
      isotp = isotpj ?? '';
    });
  }
  String otpVerification = '';
  Future testingOtp()async{
    String? testing = await otpVerificationStatus();
    setState(() {
      otpVerification = testing ?? '';
    });
  }


  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    animation1 = Tween<double>(begin: 10, end: 30).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });
    _controller.forward();

    Timer(Duration(seconds: 2), () {
      setState(() {
        _fontSize = 1.06;
      });
    });

    Timer(Duration(seconds: 2), () {
      setState(() {
        _containerSize = 90.w;
        _containerOpacity = 1;
      });
    });


    testingOtp().whenComplete(() {
      log('phoenix testing ===>>> $otpVerification');
    });
    getUsername().whenComplete(
            () => testingOtp().whenComplete(() => Timer(Duration(seconds: 3), () {
          log('user - $user \nisotp - ${otpVerification}');
          if (user != '' && otpVerification == 'done') {
            // Get.off(HomeScreen());
            Navigator.pushReplacement(context, PageTransition(HomeScreen()));

          } else {
            // Get.off(HomeScreen());
            // Get.off(GoogleSignInScreen());
            Navigator.pushReplacement(context, PageTransition(GoogleSignInScreen()));
          }
        })));

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double _width = MediaQuery.of(context).size.width;
    // double _height = MediaQuery.of(context).size.height;

    return Material(
      color: Colors.black,
      child: Center(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 2000),
          curve: Curves.fastLinearToSlowEaseIn,
          opacity: _containerOpacity,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 2000),
            curve: Curves.fastLinearToSlowEaseIn,
            height: _containerSize,
            width:  _containerSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Image.asset('assets/images/phoenix_apps.png'),
          ),
        ),
      ),
    );
  }
}
