import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:surat_weavers_new/library.dart';
import 'package:surat_weavers_new/testing2.dart';
import 'package:surat_weavers_new/testing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    log('${kFirebase.currentUser ?? ''}');
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          theme: ThemeData(

            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: PhoenixThemeColor(), width: 2),
                  borderRadius: BorderRadius.circular(10)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            primaryColor: PhoenixThemeColor(),
          ).copyWith(
            colorScheme: ThemeData().colorScheme.copyWith(
              primary: PhoenixThemeColor(),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          // home: Testing(),
        );      },
    );
  }
}

Color PhoenixThemeColor() => Color(0xff036274);

/*
class PageTransition extends PageRouteBuilder {
  final Widget page;

  PageTransition(this.page)
      : super(
    pageBuilder: (context, animation, anotherAnimation) => page,
    transitionDuration: Duration(milliseconds: 1000),

    transitionsBuilder: (context, animation, anotherAnimation, child) {
      animation = CurvedAnimation(
        curve: Curves.fastLinearToSlowEaseIn,
        parent: animation,
      );
      return Align(
        alignment: Alignment.bottomCenter,
        child: SizeTransition(
          sizeFactor: animation,
          child: page,
          axisAlignment: 0,
        ),
      );
    },
  );
}
*/


PageTransition(page){
  return CupertinoPageRoute(builder: (context) => page,);
}