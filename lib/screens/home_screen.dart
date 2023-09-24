import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:surat_weavers_new/edit_requests.dart';
import 'package:surat_weavers_new/export_data.dart';
import 'package:surat_weavers_new/library.dart';
import 'package:surat_weavers_new/screens/group_chat.dart';
import 'package:surat_weavers_new/screens/new_chat_screen.dart';
import 'package:surat_weavers_new/screens/show_all_brokers.dart';
import 'package:surat_weavers_new/testing_screen.dart';
import 'dart:developer';
import 'show_all_parties.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

late String userName;
String otpxx = '';
final gglobalKey = GlobalKey<ScaffoldState>();

class _HomeScreenState extends State<HomeScreen> {
/*  String? companyName;
  String? email;
  String? mobile;
  String? address;
  String? gstNo;*/
  // final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  final partyName = TextEditingController();
  final partyAddress = TextEditingController();
  final partyGstNo = TextEditingController();
  final partyMobileNo = TextEditingController();

  final _searchController = TextEditingController();
  String searchText = '';

  NewPartyController newPartyController = Get.put(NewPartyController());
  final drawerKey = GlobalKey<DrawerControllerState>();

  Future getData() async {
    String? data = await SharedPrefService.getUsername();
    log('currentuser ---->>>>>> ${kFirebase.currentUser!.email}');
    String? otpcheck =
        await SharedPrefService.getOtpCheck(currentUsername: name);
    setState(() {
      userName = data ?? '';
      otpxx = otpcheck ?? '';
    });
    // log(userName);
  }

  @override
  void initState() {
    getData();
    setState(() {
      log('---------date testing ${DateTime.now().toString().split(' ')[0]}');
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    });
    log('otp ---->>>> ${otpxx}');
    super.initState();
  }

  int currenTab = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeDetails(),
      BrokerScreen(),
      NewChatScreen(),
      // TestingScreen(),
      ContactUs(),
      FeedBack(),
    ];
    // getUserData();
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: gglobalKey,
      drawer: Drawer(
        key: drawerKey,
        child: mainDrawer(),
      ),
      bottomNavigationBar: Container(
        height: 8.h,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10.sp,
          unselectedFontSize: 8.sp,
          selectedLabelStyle: TextStyle(color: PhoenixThemeColor()),
          iconSize: 17.sp,
          // selectedLabelStyle: TextStyle(fontSize: 17),
          onTap: (int value) {
            setState(() {
              currenTab = value;
            });
          },
          currentIndex: currenTab,
          items: [
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                'assets/images/home.png',
                height: 17.sp,
                color: PhoenixThemeColor(),
              ),
              icon: Image.asset('assets/images/home.png', height: 17.sp),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined),
              label: 'Brokers',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.group_outlined,
                color: PhoenixThemeColor(),
              ),
              icon: Icon(
                Icons.group_outlined,
                color: Colors.black,
              ),
              label: 'Group Chat',
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                'assets/images/contact-mail.png',
                height: 17.sp,
                color: PhoenixThemeColor(),
              ),
              icon:
                  Image.asset('assets/images/contact-mail.png', height: 17.sp),
              label: 'Contact Us',
            ),
          ],
        ),
      ),
      body: screens[currenTab],
    );
  }

  /// MAIN DRAWER
  dynamic mainDrawer() {
    return SafeArea(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  '${kFirebase.currentUser != null ? kFirebase.currentUser!.photoURL : ''}'),
            ),
            title: Text(
              'Welcome,',
              style: TextStyle(fontSize: 17.sp),
            ),
            subtitle: Text(
              kFirebase.currentUser != null
                  ? kFirebase.currentUser!.displayName.toString().capitalize!
                  : 'try rejoin',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () {
              signOutGoogle();
              SharedPrefService.logOut();
              // Get.off(GoogleSignInScreen());
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context, PageTransition(GoogleSignInScreen()));
            },
            child: ListTile(
              title: Text(
                'log out',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13.sp,
                ),
              ),
              trailing: Icon(
                Icons.logout,
                color: Colors.black87,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.off(InterestScreen());
            },
            child: ListTile(
              title: Text(
                'Interest Calculator',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13.sp,
                ),
              ),
              trailing: Icon(
                Icons.calculate,
                size: 20.sp,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // Get.to(ShowAllParties());
              Navigator.pop(context);
              Navigator.push(context, PageTransition(ShowAllParties()));
            },
            child: ListTile(
              title: Text(
                'Show all Parties',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13.sp,
                ),
              ),
              trailing: Icon(
                Icons.group_outlined,
                size: 20.sp,
              ),
            ),
          ),
          ListTile(
            onTap: () {
              // Get.to(ShowAllBrokers());
              Navigator.pop(context);
              Navigator.push(context, PageTransition(ShowAllBrokers()));
            },
            title: Text(
              'Show all Brokers',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 13.sp,
              ),
            ),
            trailing: Icon(
              Icons.person_outline_outlined,
              size: 20.sp,
            ),
          ),
          if (kFirebase.currentUser!.email == 'niyam4103@gmail.com')
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EditReqScreen(),
                    ));
              },
              title: Text(
                'Edit Requests',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13.sp,
                ),
              ),
              trailing: Icon(
                Icons.edit,
                size: 20.sp,
              ),
            )
          else
            SizedBox(),

          /// feedback
          //    InkWell(
          //      onTap: () {
          //
          //      },
          //      child: ListTile(
          //        title: Text(
          //          'Feedback',
          //          style: TextStyle(
          //            color: Colors.black87,
          //            fontSize: 13.sp,
          //          ),
          //        ),
          //        trailing:
          //        Image.asset('assets/images/feedback.png', height: 17.sp),
          //      ),
          //    ),
        ],
      ),
    );
  }
}

class HomeDetails extends StatefulWidget {
  const HomeDetails({Key? key}) : super(key: key);

  @override
  _HomeDetailsState createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> {
  String? companyName;
// String? email;
// String? mobile;
// String? address;
// String? gstNo;
// final GlobalKey<ScaffoldState> globalKey = GlobalKey();
//
  final partyName = TextEditingController();
  final partyAddress = TextEditingController();
  final partyGstNo = TextEditingController();
  final partyMobileNo = TextEditingController();

  final _searchController = TextEditingController();
  String searchText = '';

  NewPartyController newPartyController = Get.put(NewPartyController());
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
        floatingActionButton: FloatingActionButton.extended(
          label: Text(
            '+ Add Party',
            style: TextStyle(fontSize: 10.sp),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          backgroundColor: PhoenixThemeColor(),
          onPressed: () => showGeneralDialog(
            context: context,
            pageBuilder: (ctx, a1, a2) {
              return Container();
            },
            transitionBuilder: (ctx, a1, a2, child) {
              var curve = Curves.easeInOut.transform(a1.value);
              return Transform.scale(
                scale: curve,
                child: AlertDialog(
                  title: Text('Add New Party'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: partyName,
                        decoration: InputDecoration(hintText: 'Party Name'),
                      ),
                      SizedBox(height: 3.h),
                      TextField(
                        controller: partyAddress,
                        decoration: InputDecoration(hintText: 'Address'),
                      ),
                      SizedBox(height: 3.h),
                      TextField(
                        controller: partyGstNo,
                        decoration: InputDecoration(hintText: 'Gst No.'),
                        maxLength: 15,
                      ),
                      TextField(
                        controller: partyMobileNo,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(hintText: 'Mobile No.'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await FirebaseFirestore.instance
                              .collection('MainPartyDataCenter')
                              .doc(partyGstNo.text.toString().toUpperCase())
                              .set({
                            'party_gst_no': partyGstNo.text.toUpperCase(),
                            'party_company_name': partyName.text.capitalize,
                            'party_address': partyAddress.text,
                            'party_mobile': partyMobileNo.text,
                          });
                          await FirebaseFirestore.instance
                              .collection('rating')
                              .doc(partyGstNo.text.toString().toUpperCase())
                              .set({
                            'party_gst_no': partyGstNo.text.toUpperCase(),
                            'party_company_name': partyName.text.capitalize,
                            'party_address': partyAddress.text,
                            'party_mobile': partyMobileNo.text,
                            'avg rating': 0.0,
                            'who rated': {},
                            'comments': {},
                          });

                          partyName.clear();
                          partyGstNo.clear();
                          partyAddress.clear();
                          partyMobileNo.clear();
                        },
                        child: Text('add')),
                    TextButton(
                        onPressed: () {
                          partyName.clear();
                          partyGstNo.clear();
                          partyAddress.clear();
                          partyMobileNo.clear();
                          Navigator.pop(context);
                        },
                        child: Text('cancel')),
                  ],
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              setState(() {
                gglobalKey.currentState!.openDrawer();
              });
            },
            icon: Icon(Icons.menu),
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: TextField(
            controller: _searchController,
            cursorColor: PhoenixThemeColor(),
            decoration: InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PhoenixThemeColor())),
              focusColor: PhoenixThemeColor(),
              hintText: 'Party Name / GST No.',
              suffixIconConstraints:
                  BoxConstraints.loose(MediaQuery.of(context).size),
              suffixIcon: Image.asset(
                'assets/images/search.png',
                height: 13.sp,
                // width: 5.sp,
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/rateme.jpg'), opacity: 0.05),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('rating').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              _searchController.addListener(() {
                setState(() {
                  searchText = _searchController.text;
                });
              });
              if (snapshot.hasData) {
                // List data3 = snapshot.data!.docs;
                List data = snapshot.data!.docs;
                // ignore: prefer_is_empty
                var showallparty = 'yes';
                if (searchText.length > 0) {
                  List data1 = data.where((element) {
                    return element
                        .get('party_gst_no')
                        .toString()
                        .toLowerCase()
                        .contains(searchText.toLowerCase());
                  }).toList();
                  List data2 = data.where((element) {
                    return element
                        .get('party_company_name')
                        .toString()
                        .toLowerCase()
                        .contains(searchText.toLowerCase());
                  }).toList();
                  // data = (data1 + data2)..map((map) => jsonEncode(map)).toList().toSet().toList().map((item) => jsonDecode(item)).toList();
                  data = (data1 + data2).toSet().toList();
                }
                if (data.isNotEmpty) {
                  return ListView.builder(
                    itemCount: data.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      if (searchText.isNotEmpty || showallparty == 'yes') {
                        return Column(
                          children: [
                            SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                /* Get.to(
                                  // RatingScreen(
                                  //   companyName: data[index]
                                  //           ['party_company_name']
                                  //       .toString(),
                                  //   gstNo:
                                  //       data[index]['party_gst_no'].toString(),
                                  //   mobile:
                                  //       data[index]['party_mobile'].toString(),
                                  //   address:
                                  //       data[index]['party_address'].toString(),
                                  // ),
                                  TestingRatingScreen(
                                    companyName: data[index]
                                            ['party_company_name']
                                        .toString(),
                                    gstNo:
                                        data[index]['party_gst_no'].toString(),
                                    mobile:
                                        data[index]['party_mobile'].toString(),
                                    address:
                                        data[index]['party_address'].toString(),
                                  ),
                                );*/
                                Navigator.of(context).push(CupertinoPageRoute(
                                  builder: (context) => TestingRatingScreen(
                                    companyName: data[index]
                                            ['party_company_name']
                                        .toString(),
                                    gstNo:
                                        data[index]['party_gst_no'].toString(),
                                    mobile:
                                        data[index]['party_mobile'].toString(),
                                    address:
                                        data[index]['party_address'].toString(),
                                  ),
                                ));
                              },
                              child: ListTile(
                                title: Text(
                                  data[index]['party_company_name']
                                      .toString()
                                      .capitalize!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 7),
                                    Text('GST No : ' +
                                        data[index]['party_gst_no']),
                                    SizedBox(height: 7),
                                    Text('Mobile : ' +
                                        data[index]['party_mobile']),
                                    SizedBox(height: 7),
                                    Text('Address : ' +
                                        data[index]['party_address']
                                            .toString()
                                            .capitalize!),
                                    SizedBox(height: 7),
                                    Row(
                                      children: [
                                        Text(
                                            'Average Rating : ${data[index]['avg rating']}'),
                                        Spacer(flex: 1),
                                        Text(
                                            '( ${data[index]['who rated'].length} )'),
                                        Spacer(flex: 2),
                                        RatingBar.builder(
                                          itemSize: 20,
                                          allowHalfRating: true,
                                          ignoreGestures: true,
                                          glow: false,
                                          initialRating: data[index]
                                              ['avg rating'],
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (double value) {},
                                        ),
                                        Spacer(flex: 7),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return Center(
                    child: Text('No Party Found'),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
/*showDialog(
              context: context,
              // ignore: avoid_types_as_parameter_names
              builder: (BuildContext) {
                return AlertDialog(
                  title: Text('Add New Party'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: partyName,
                        decoration: InputDecoration(hintText: 'Party Name'),
                      ),
                      SizedBox(height: 3.h),
                      TextField(
                        controller: partyAddress,
                        decoration: InputDecoration(hintText: 'Address'),
                      ),
                      SizedBox(height: 3.h),
                      TextField(
                        controller: partyGstNo,
                        decoration: InputDecoration(hintText: 'Gst No.'),
                        maxLength: 15,
                      ),
                      TextField(
                        controller: partyMobileNo,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(hintText: 'Mobile No.'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await FirebaseFirestore.instance
                              .collection('MainPartyDataCenter')
                              .doc(partyGstNo.text.toString().toUpperCase())
                              .set({
                            'party_gst_no': partyGstNo.text.toUpperCase(),
                            'party_company_name': partyName.text.capitalize,
                            'party_address': partyAddress.text,
                            'party_mobile': partyMobileNo.text,
                          });
                          await FirebaseFirestore.instance
                              .collection('rating')
                              .doc(partyGstNo.text.toString().toUpperCase())
                              .set({
                            'party_gst_no': partyGstNo.text.toUpperCase(),
                            'party_company_name': partyName.text.capitalize,
                            'party_address': partyAddress.text,
                            'party_mobile': partyMobileNo.text,
                            'avg rating': 0.0,
                            'who rated': {},
                            'comments': {},
                          });

                          partyName.clear();
                          partyGstNo.clear();
                          partyAddress.clear();
                          partyMobileNo.clear();
                        },
                        child: Text('add')),
                    TextButton(
                        onPressed: () {
                          partyName.clear();
                          partyGstNo.clear();
                          partyAddress.clear();
                          partyMobileNo.clear();
                          Navigator.pop(context);
                        },
                        child: Text('cancel')),
                  ],
                );
              },
            );*/
