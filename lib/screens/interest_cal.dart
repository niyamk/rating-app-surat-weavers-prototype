import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:surat_weavers_new/library.dart';

class InterestScreen extends StatefulWidget {
  const InterestScreen({Key? key}) : super(key: key);

  @override
  _InterestScreenState createState() => _InterestScreenState();
}

Map d = {};
int initialBills = 1;
String netInitialBill = '';

class _InterestScreenState extends State<InterestScreen> {
  // int initialBills = 1;
  // int totalInterest = 0;
  // List l = [];
  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    initialBills = 1;
    d = {};
    super.initState();
  }

  @override
  void dispose() {
    log('!!!!!!!!!!dispose called!!!!!!!!');
    initialBills = 0;
    // d.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      key: globalKey,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage('${kFirebase.currentUser!.photoURL}'),
                ),
                title: Text(
                  'Welcome,',
                  style: TextStyle(fontSize: 17.sp),
                ),
                subtitle: Text(
                  kFirebase.currentUser!.displayName.toString().capitalize!,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  signOutGoogle();
                  SharedPrefService.logOut();
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown
                  ]);
                  Get.off(GoogleSignInScreen());
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
                  setState(() {
                    initialBills = 0;
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown
                    ]);
                    Get.off((HomeScreen()));
                    // Timer(Duration(seconds: 1), () => Get.off(HomeScreen()));
                  });
                },
                child: ListTile(
                    title: Text(
                  'Home Page',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 13.sp,
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () {
              globalKey.currentState!.openDrawer();
            },
            child: Container(
                child: Icon(
              Icons.menu,
              color: Colors.black87,
            ))),
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Text(
                'Bill no.',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
              ),
            ),
            Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    'Bill',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    'Date',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    'Payment',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    'Date',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Text(
                'Amount',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
              ),
            ),
            Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    'Due',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    'Days',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    'Interest',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    'Days',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 1),
            Expanded(
              flex: 1,
              child: Text(
                'Interest',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                ),
              ),
            ),
            // Spacer(flex: 1),
          ],
        ),
      ),
      // resizeToAvoidBottomInset: false,
      body: initialBills != 0
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: initialBills,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          DetailsRow(),
                          SizedBox(height: 9),
                        ],
                      );
                    },
                  ),
                  Row(
                    children: [
                      Spacer(flex: 1),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            initialBills++;
                          });
                        },
                        child: Text('Add New Bill'),
                      ),
                      Spacer(flex: 1),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            d.remove('${initialBills}');
                            initialBills--;
                          });
                        },
                        child: Text('Remove Last Bill'),
                      ),
                      Spacer(flex: 7),
                      Container(
                        // height: 50,
                        // width: 150,
                        padding: EdgeInsets.all(14),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: PhoenixThemeColor(),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Text(
                          'Total Interest : ${netInitialBill.isEmpty ? 0 : netInitialBill}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                      Spacer(flex: 1),
                    ],
                  ),
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              child: Text(''),
            ),
    );
  }
}

class DetailsRow extends StatefulWidget {
  DetailsRow({
    Key? key,
  }) : super(key: key);
  // final int initialBills;
  @override
  _DetailsRowState createState() => _DetailsRowState();
}

class _DetailsRowState extends State<DetailsRow> {
  DateTime? billDate;
  DateTime? paymentDate;
  final dueDays = TextEditingController();
  final amount = TextEditingController();
  int billno = initialBills;
  @override
  Widget build(BuildContext context) {
    String interest = (billDate != null &&
                paymentDate != null &&
                amount.text != ''
            ? (((paymentDate?.difference(billDate!).inDays)! -
                        (int.parse(
                            dueDays.text.isNotEmpty ? dueDays.text : '0'))) *
                    (18 / 36500) *
                    int.parse(amount.text))
                .toStringAsFixed(2)
            : 0.0)
        .toString();
    d['${billno}'] = double.parse('$interest');
    var t = d.values.toList().reduce((value, element) => value + element);
    netInitialBill = double.parse('${t}').toStringAsFixed(2);
    log('---------------------- HI PHOENIX ${double.parse('${d.values.toList().reduce((value, element) => value + element)}').toStringAsFixed(2)} ---------------------------');
    return Container(
      height: 45,
      child: Row(
        children: [
          // SizedBox(width: 10),
          // Expanded(child: TextField()),
          Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: Text('${billno}'),
              )),
          // SizedBox(width: 10),
          Expanded(
              flex: 2,
              child: TextField(
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  setState(() {});
                },
              )),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000, 1, 1),
                  lastDate: DateTime(2030, 1, 1),
                ).then((value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    //for rebuilding the ui
                    billDate = value;
                  });
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(billDate != null
                      ? DateFormat('dd-MM-yyyy').format(billDate!)
                      : " "),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000, 1, 1),
                  lastDate: DateTime(2030, 1, 1),
                ).then((value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    paymentDate = value;
                  });
                });
              },
              child: Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(paymentDate != null
                      ? DateFormat('dd-MM-yyyy').format(paymentDate!)
                      : " "),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
              flex: 2,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: amount,
                onSubmitted: (value) {
                  setState(() {});
                },
              )),
          SizedBox(width: 10),
          Expanded(
              flex: 2,
              child: TextField(
                decoration: InputDecoration(hintText: '0'),
                controller: dueDays,
                onSubmitted: (value) {
                  setState(() {});
                },
              )),
          SizedBox(width: 10),
          Expanded(
              flex: 2,
              child: Center(
                child: Text(
                    '${(billDate != null && paymentDate != null) ? (paymentDate?.difference(billDate!).inDays)! - (int.parse(dueDays.text.isNotEmpty ? dueDays.text : '0')) : 0}'),
              )),
          SizedBox(width: 10),
          Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  '${interest}',
                  // ' ${billDate != null && paymentDate != null && amount.text != '' ? (((paymentDate?.difference(billDate!).inDays)! - (int.parse(dueDays.text.isNotEmpty ? dueDays.text : '0'))) * (18 / 36500) * int.parse(amount.text)).toStringAsFixed(2) : 0} ',
                ),
              )),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
