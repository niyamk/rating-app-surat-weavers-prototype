import 'package:surat_weavers_new/library.dart';
import 'package:url_launcher/url_launcher.dart';
/*
ContactUs(context) {
  // return Align(
  //   alignment: Alignment.bottomRight,
  //   child: Container(
  //     height: 290,
  //     width: 150,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey,
  //           blurRadius: 4,
  //           offset: Offset(2, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         Icon(
  //           Icons.info_outline,
  //           color: Colors.black87,
  //         ),
  //         Divider(),
  //         InkWell(
  //           onTap: () {
  //             launch('https://wa.me/+91 9727872141');
  //           },
  //           child: ListTile(
  //             leading: Text(
  //               'Whatsapp',
  //               style: MyTextStyle(),
  //             ),
  //             trailing: Icon(
  //               Icons.whatsapp_outlined,
  //               color: Colors.green,
  //             ),
  //           ),
  //         ),
  //         InkWell(
  //           onTap: () {
  //             launch('https://wa.me/+91 9727872141');
  //           },
  //           child: ListTile(
  //             leading: Text(
  //               'Facebook',
  //               style: MyTextStyle(),
  //             ),
  //             trailing: Icon(
  //               Icons.facebook_outlined,
  //               color: Colors.indigoAccent,
  //             ),
  //           ),
  //         ),
  //         ListTile(
  //           leading: Text(
  //             'Gmail',
  //             style: MyTextStyle(),
  //           ),
  //           trailing: Icon(
  //             Icons.email_outlined,
  //             color: Colors.redAccent,
  //           ),
  //         ),
  //         ListTile(
  //           leading: Text(
  //             'Call',
  //             style: MyTextStyle(),
  //           ),
  //           trailing: Icon(
  //             Icons.call,
  //             color: Colors.blue,
  //           ),
  //         ),
  //       ],
  //     ),
  //   ),
  // );
  return SafeArea(
    child: Column(
      children: [
        AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
        ListTile(
          leading: Text(
            'Whatsapp',
            style: MyTextStyle(),
          ),
        ),
        ListTile(),
        ListTile(),
        ListTile(),
      ],
    ),
  );
}
*/

MyTextStyle() {
  return TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp);
}

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();
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
        key: globalKey,
        // drawer: Drawer(
        //   child: SafeArea(
        //     child: Column(
        //       children: [
        //         ListTile(
        //           leading: CircleAvatar(
        //             radius: 30,
        //             backgroundImage:
        //                 NetworkImage('${kFirebase.currentUser!.photoURL}'),
        //           ),
        //           title: Text(
        //             'welcome,',
        //             style: TextStyle(fontSize: 20),
        //           ),
        //           subtitle: Text(
        //             kFirebase.currentUser!.displayName.toString(),
        //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //           ),
        //         ),
        //         InkWell(
        //           onTap: () {
        //             signOutGoogle();
        //             SharedPrefService.logOut();
        //             Get.off(SignUpScreen());
        //           },
        //           child: ListTile(
        //             title: Text(
        //               'log out',
        //               style: TextStyle(
        //                 color: Colors.grey,
        //               ),
        //             ),
        //             trailing: Icon(
        //               Icons.logout,
        //               color: Colors.grey,
        //             ),
        //           ),
        //         ),
        //         InkWell(
        //           onTap: () {
        //             Get.off(InterestScreen());
        //           },
        //           child: ListTile(
        //             title: Text(
        //               'Interest Calculator',
        //               style: TextStyle(
        //                 color: Colors.grey,
        //                 fontSize: 16,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: SafeArea(
          child: Column(
            children: [
              // AppBar(
              //   elevation: 1,
              //   leading: IconButton(
              //     onPressed: () {
              //       setState(() {
              //         globalKey.currentState?.openDrawer();
              //       });
              //     },
              //     icon: Icon(Icons.menu),
              //     color: Colors.black,
              //   ),
              //   backgroundColor: Colors.white,
              // ),
              InkWell(
                onTap: () {
                  launch('https://wa.me/+91 9099024103?text=h');
                },
                child: ListTile(
                  title: Text(
                    'Whatsapp',
                    style: MyTextStyle(),
                  ),
                  leading: Icon(
                    // Icons.whatsapp_outlined,
                    Icons.access_time_outlined,
                    size: 21.sp,
                    color: Colors.green,
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  launch(
                      'fb://facewebmodal/f?href=https://www.facebook.com/Suratweaversgroup');
                },
                child: ListTile(
                  title: Text(
                    'Facebook',
                    style: MyTextStyle(),
                  ),
                  leading: Icon(
                    Icons.facebook_outlined,
                    size: 21.sp,
                    color: Colors.indigoAccent,
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  launch('mailto:skhan4103@gmail.com');
                },
                child: ListTile(
                  title: Text(
                    'Email',
                    style: MyTextStyle(),
                  ),
                  leading: Icon(
                    Icons.email_outlined,
                    size: 21.sp,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  launch('tel:91 9099024103');
                },
                child: ListTile(
                  title: Text(
                    'Call',
                    style: MyTextStyle(),
                  ),
                  leading: Icon(
                    Icons.call,
                    size: 21.sp,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  launch('https://t.me/+avpVYd4a16LeTXE6');
                },
                child: ListTile(
                  title: Text(
                    'Join Telegram Group',
                    style: MyTextStyle(),
                  ),
                  leading: Icon(
                    Icons.telegram_outlined,
                    size: 21.sp,
                    color: Colors.blue,
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
