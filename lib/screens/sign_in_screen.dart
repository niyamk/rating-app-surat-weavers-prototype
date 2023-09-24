import 'dart:developer';
import 'package:surat_weavers_new/library.dart';

import 'newuserData_screen.dart';


class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

String otpcheck = '';
String currentuser = '';
class _GoogleSignInScreenState extends State<GoogleSignInScreen> {

  Future getUsername() async {
    String? username = await SharedPrefService.getUsername();
    setState(() {
      currentuser = username ?? '';
    });
  }

  Future getOtpCheck() async{
    String? data = await SharedPrefService.getOtpCheck(currentUsername: user);
    setState(() {
      otpcheck = data ?? '';
    log('otpcheck ---->>>> ${otpcheck}');
    });
  }

  String otpVerification = '';
  Future testingOtp()async{
    String testing = await otpVerificationStatus();
    setState(() {
      otpVerification = testing;
    });
  }

  @override
  void initState() {
    getUsername().whenComplete(() => testingOtp());
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    Future<bool> showExitPopup() async {
      return await showDialog( //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit an App?'),
          actions:[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              //return false when click on "NO"
              child:Text('No'),
            ),

            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              //return true when click on "Yes"
              child:Text('Yes'),
            ),

          ],
        ),
      )??false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        backgroundColor: Color(0xffFF324BCD),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset('assets/images/rating_logo.png',
                      height: 120.sp),
                ),
                Text(
                  'Welcome,',
                  style: TextStyle(color: Colors.white, fontSize: 30.sp),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Sign In through your google id : ',
                  style: TextStyle(color: Colors.white, fontSize: 17.sp),
                ),
                SizedBox(height: 3.h),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white)),
                    onPressed: () async {
                      try {

                         await signInWithGoogle().whenComplete(() => testingOtp().whenComplete(()  {

                         log('isnewuser---->> ${isNewUser}');
                             log('otpcheck---->> ${otpVerification}');
                             SharedPrefService.setUser(username: name)
                             .then((value) {
                           log(' ------------- isnewuser ${isNewUser!} and otpcheck ${otpcheck} and net condition ${isNewUser! && otpcheck == ''} and name : ${name} --------------');
                           /*   if (otpcheck == '') {
                                  Get.off(GetData());
                                } else {
                                  Get.off(HomeScreen());
                                }*/
                            testingOtp().whenComplete(() {
                            print('phoenix jod -- $otpcheck');
                           if (isNewUser!){
                             // Get.off(GetData());

                           }else if(otpVerification == 'nope'){

                             // Get.off(GetData());
                             Navigator.pushReplacement(context, PageTransition(GetData()));
                           }else{
                             // Get.off(HomeScreen());
                             Navigator.pushReplacement(context, PageTransition(HomeScreen()));

                           }
                            });
                         });
                      }) );
                      } catch (e) {
                        // Get.off(GetData());
                        print('error ===>>>> $e');
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/googleLogo.png',
                          height: 14.sp,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Google',
                          style: TextStyle(
                              color: Color(0xffFF324BCD), fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ),
                ),
                // SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
