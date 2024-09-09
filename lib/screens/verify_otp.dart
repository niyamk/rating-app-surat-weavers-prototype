import 'package:flutter/material.dart';
import 'package:surat_weavers_new/library.dart';
import 'newuserData_screen.dart';
import 'dart:developer';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:alt_sms_autofill/alt_sms_autofill.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({Key? key}) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final TextEditingController _otp = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldState>();
  String? otp;
  String _code = '';

  Future otpVerificationDone() async {
    await FirebaseFirestore.instance
        .collection('otpVerification')
        .doc(kFirebase.currentUser!.uid.toString())
        .set({'otpVerification': 'done'});
  }

  Future<void> verificationOTPCode(String? otp) async {
    print('--------func called--------------------');
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationCode!, smsCode: otp!);
    if (phoneAuthCredential.smsCode != otp) {
      log("verificationID ----------- ${phoneAuthCredential.verificationId}");
      log("smsCode ----------- ${phoneAuthCredential.smsCode}");
      log('OTP written ------------- ${otp}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter valid otp"),
        ),
      );
      return;
    } else {
      otpVerificationDone().whenComplete(() =>
          Navigator.pushReplacement(context, PageTransition(HomeScreen())));
    }
  }

  void initState() {
    _listenOtp();
    super.initState();
  }

  void _listenOtp() async {
    await SmsAutoFill().listenForCode();
    // setState(() {});
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        key: _globalKey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PinFieldAutoFill(
              decoration: UnderlineDecoration(
                textStyle: TextStyle(fontSize: 20, color: Colors.black),
                colorBuilder: FixedColorBuilder(PhoenixThemeColor()),
              ),
              currentCode: _code,
              onCodeSubmitted: (code) {
                // log('------------------auto filled code${code}------------------------');
              },
              onCodeChanged: (code) {
                log('------------------auto filled code1${code}------------------------');
                if (code!.length == 6) {
                  _code = code;
                  log('------------------auto filled code2${code}------------------------');

                  FocusScope.of(context).requestFocus(FocusNode());
                }
                log('---------------------_code ${_code}');
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  print('---------button pressed------------');

                  setState(() {
                    // verificationOTPCode(_code);
                    // log('phoenix look here ----->>>> ${name}');
                    // otpVerificationDone().whenComplete(() => Get.off(()=> HomeScreen()));
                    SharedPrefService.setOtpCheck(
                            OTP: 'true', currentUsername: name)
                        .whenComplete(() => Get.off(() => HomeScreen()));
                  });
                },
                child: Text('verify')),
          ],
        ),
        /*body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 150),
                Container(
                    height: 200,
                    width: 200,
                    // color: Color(0xffFF324BCD),
                    child: Image.asset('assets/images/rating_logo.png')),
                Align(
                  alignment: Alignment(-0.7, 0),
                  child: Text(
                    'Enter OTP',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 10),
                PinCodeTextField(
                    appContext: context,
                    length: 6,
                    onCompleted: (value) {
                      setState(() {});
                    },
                    onChanged: (String value) {},
                    pinTheme: PinTheme(inactiveColor: Color(0xffFF324BCD)),
                    onSubmitted: (String verificationCode) {
                      setState(() {
                        otp = verificationCode;
                      });
                    }),
                ElevatedButton(
                    onPressed: () {
                      print('---------button pressed------------');
                      log('-----print not working-------------');
                      setState(() {
                        verificationOTPCode(otp);
                      });
                      setState(() {});
                    },
                    child: Text('verify')),
              ],
            ),
          ),
        ),*/
      ),
    );
  }
}
