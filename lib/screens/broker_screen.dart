
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:surat_weavers_new/library.dart';
import 'package:surat_weavers_new/screens/rating_broker.dart';



class BrokerScreen extends StatefulWidget {
  const BrokerScreen({Key? key}) : super(key: key);

  @override
  _BrokerScreenState createState() => _BrokerScreenState();
}

class _BrokerScreenState extends State<BrokerScreen> {
  final _searchController = TextEditingController();
  String searchText = '';
  final brokerName = TextEditingController();
  final mobileNo1 = TextEditingController();
  final mobileNo2 = TextEditingController();
  var BrokerId = '';
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random.secure();
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
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
        floatingActionButton: FloatingActionButton.extended(
          label: Text(
            '+ Add Broker',
            style: TextStyle(fontSize: 10.sp),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          backgroundColor: PhoenixThemeColor(),
          onPressed: () {
            showDialog(
              context: context,
              // ignore: avoid_types_as_parameter_names
              builder: (BuildContext) {
                return AlertDialog(
                  title: Text('Add New Broker'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: brokerName,
                        decoration: InputDecoration(hintText: 'Broker Name'),
                      ),
                      SizedBox(height: 3.h),
                      TextField(
                        controller: mobileNo1,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(hintText: 'Mobile No. 1'),
                      ),
                      TextField(
                        controller: mobileNo2,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration:
                            InputDecoration(hintText: 'Mobile No. 2 (Optional) '),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          String brokerId = getRandomString(15);
                          brokerId = brokerId;
                          Navigator.pop(context);
                          if (mobileNo1.text.isNotEmpty) {
                            await FirebaseFirestore.instance
                                .collection('brokers')
                                .doc(brokerId)
                                .set({
                              'broker_name': brokerName.text,
                              'broker_mobile_1': mobileNo1.text,
                              'broker_mobile_2': mobileNo2.text.isNotEmpty
                                  ? mobileNo2.text
                                  : 'not assigned',
                              'broker_id': brokerId,
                              'avg rating': 0.0,
                              'comments': {},
                              'who rated': {},
                            });
                            mobileNo1.clear();
                            mobileNo2.clear();
                            brokerName.clear();
                          }
                          ;
                        },
                        child: Text('add')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          mobileNo1.clear();
                          mobileNo2.clear();
                          brokerName.clear();
                        },
                        child: Text('cancel')),
                  ],
                );
              },
            );
          },
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
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            cursorColor: PhoenixThemeColor(),
            decoration: InputDecoration(
              border: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PhoenixThemeColor())),
              focusColor: PhoenixThemeColor(),
              hintText: 'search by name of Broker',
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
            stream: FirebaseFirestore.instance.collection('brokers').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                List data = snapshot.data!.docs;
                if (searchText.length > 0) {
                  data = data.where((element) {
                    return element
                        .get('broker_name')
                        .toString()
                        .toLowerCase()
                        .contains(searchText.toLowerCase());
                  }).toList();
                }
                if (data.isNotEmpty) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (searchText.isNotEmpty) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                // Get.to(RatingBroker(
                                //   brokerId: BrokerId,
                                //   brokerName: brokerName.text,
                                //   brokerMobile1: mobileNo1.text,
                                //   brokerMobile2: mobileNo2.text.isEmpty
                                //       ? 'not assigned'
                                //       : mobileNo2.text,
                                // ));
                                Get.to(RatingBroker(
                                  brokerName: data[index]['broker_name'],
                                  brokerId: data[index]['broker_id'],
                                  brokerMobile1: data[index]['broker_mobile_1'],
                                  brokerMobile2: data[index]['broker_mobile_2'],
                                ));
                              },
                              child: ListTile(
                                title: Text(
                                  'Name : ${data[index]['broker_name']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 6),
                                    Text(
                                        '1st Mobile No : ${data[index]['broker_mobile_1']}'),
                                    SizedBox(height: 6),
                                    Text(
                                        '2nd Mobile No : ${data[index]['broker_mobile_2']}'),
                                    SizedBox(height: 6),
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
                                    SizedBox(height: 6),
                                  ],
                                ),
                              ),
                            ),
                            // SizedBox(height: 10),
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
                    child: Text('no Broker found'),
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
