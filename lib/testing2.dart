import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:surat_weavers_new/library.dart';
import 'package:url_launcher/url_launcher.dart';

class TestingRatingScreen extends StatefulWidget {
  const TestingRatingScreen(
      {this.companyName, this.gstNo, this.mobile, this.address});

  @override
  State<TestingRatingScreen> createState() => _TestingRatingScreenState();
  final companyName;
  final gstNo;
  final mobile;
  final address;
}

late var currentGstNo;
var _data;

class _TestingRatingScreenState extends State<TestingRatingScreen> {
  double mainRating = 0;
  late Map<String, dynamic> whoRatedData;
  late double avgRating;
  late Map whoCommented;
  String? prevComment;
  final commentController = TextEditingController();

  Future getData() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docsnap = await collection.doc(kFirebase.currentUser!.uid).get();
    if (docsnap.exists) {
      setState(() {
        Map<String, dynamic>? data = docsnap.data();
        currentGstNo = data?['gst_no'];
        // log('---------------$value-------------------');
      });
    }
  }

  Future ratingDetails() async {
    var collection = FirebaseFirestore.instance.collection('rating');
    var docSnap = await collection.doc(widget.gstNo).get();
    if (docSnap.exists) {
      _data = docSnap.data();

      setState(() {
        mainRating = _data['who rated'][currentGstNo.toString()] ?? 0;
        log('----- main rating $mainRating');
        whoRatedData = _data['who rated'];
        whoCommented = _data['comments'];
        log('--------who commented ${_data['comments']}');
        prevComment = _data['comments']['$currentGstNo']['rating'] ;

        log('------phoenix testing ${whoCommented[currentGstNo]['rating part']}');

      });
    }
  }

  @override
  void initState() {
    getData().then((value) => ratingDetails());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.green,
      body: Column(
        children: [
          Container(
            height: 23.h,
            width: 100.w,
            padding: EdgeInsets.all(5.w),
            child: Image.asset('assets/images/rating_logo.png'),
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            height: 77.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.companyName,
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
                SizedBox(height: 10),
                Text(
                  widget.gstNo,
                  style:
                  TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
                ),
                SizedBox(height: 10),
                Text(
                  widget.address,
                  style:
                  TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),
                ),
                SizedBox(height: 10),
                Text(
                  widget.mobile,
                  style:
                  TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),
                ),
                SizedBox(height: 10),
                RatingBar.builder(
                  allowHalfRating: true,
                  glow: false,
                  initialRating: mainRating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (double currentGstNo) {
                    // log(value.toString());
                    setState(() {
                      mainRating = currentGstNo;
                    });
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Spacer(flex: 8),
                    ElevatedButton(
                        onPressed: () async {
                          Map totalWhoCommented = {
                            ...whoCommented,
                            ...{
                              '$currentGstNo': {
                                'date of edit': DateFormat('dd-MM-yyyy')
                                    .format(DateTime.now())
                                    .toString(),
                                'rating part':
                                commentController.text.toString().isNotEmpty
                                    ? commentController.text.toString()
                                    : prevComment ?? '-no comment-'
                              }
                            },
                          };
                          Map totalWhoRated = {
                            ...whoRatedData,
                            ...{'$currentGstNo': mainRating},
                          };
                          double avgRatingAfterTotal = ((totalWhoRated.values
                              .toList()
                              .reduce(
                                  (value, element) => value + element)) /
                              (whoRatedData.isEmpty
                                  ? 1
                                  : whoRatedData.keys.contains(currentGstNo)
                                  ? whoRatedData.length
                                  : whoRatedData.length + 1));

                          log('PRIME comment : $whoCommented');

                          FirebaseFirestore.instance.collection('rating').doc(widget.gstNo.toString()).update({
                            'avg rating': double.parse(
                                (avgRatingAfterTotal.toStringAsFixed(2))),
                            'comments': totalWhoCommented,
                            'who rated': totalWhoRated,
                          });

                          // FirebaseFirestore.instance
                          //     .collection('rating')
                          //     .doc(widget.gstNo.toString())
                          //     .set({
                          //   'who rated': totalWhoRated,
                          //   'party_address': widget.address,
                          //   'party_company_name': widget.companyName,
                          //   'party_gst_no': widget.gstNo,
                          //   'party_mobile': widget.mobile,
                          //   'avg rating': double.parse(
                          //       (avgRatingAfterTotal.toStringAsFixed(2))),
                          //   'comments': totalWhoCommented,
                          // });
                          Navigator.pop(context);
                        },
                        child: Text('save')),
                    Spacer(flex: 1),
                    ElevatedButton(
                      onPressed: () {
                        final editTextController = TextEditingController();
                        List typeList = [
                          'Company Name',
                          'Address',
                          'Mobile no.'
                        ];
                        List typeListWithDetails = [
                          widget.companyName,
                          widget.address,
                          widget.mobile
                        ];
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Select what you want to edit'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Current Company Name :- ${widget.companyName}'),
                                  Text('Current Address :- ${widget.address}'),
                                  Text(
                                      'Current Mobile no. :- ${widget.mobile}'),
                                  SizedBox(height: 10),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      typeList.length,
                                          (index) => GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Enter correct ${typeList[index]}'),
                                                content: Column(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  children: [
                                                    /*Text(
                                                  'Old ${typeList[index]} :- ${typeListWithDetails[index]}'),*/
                                                    SizedBox(height: 10),
                                                    TextField(
                                                      controller:
                                                      editTextController,
                                                      decoration:
                                                      InputDecoration(
                                                          hintText:
                                                          'enter here'),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  OutlinedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('cancel')),
                                                  OutlinedButton(
                                                      onPressed: () {
                                                        if (editTextController
                                                            .text.isNotEmpty) {
                                                          launch(
                                                              'https://wa.me/+91 87990604103?text= { ${widget.gstNo} } *${typeList[index]}* OLD ~${typeListWithDetails[index]}~ - *NEW* _${editTextController.text}_');
                                                        }
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                          'send through Whatsapp')),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            border: Border.all(
                                                color: PhoenixThemeColor(),
                                                width: 2),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              typeList[index],
                                            ),
                                            trailing: Icon(
                                                Icons.arrow_forward_ios_sharp),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('cancel'))
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Edit'),
                    ),
                    Spacer(flex: 8),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'comment',
                    labelText: 'comment',
                  ),
                ),
                SizedBox(height: 10),
//                 StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('rating')
//                       .snapshots(),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (snapshot.hasData) {
//                       List? data =  snapshot.data!.docs;
//                       return ListView.builder(
//                         itemCount: data.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return ListTile(
// title: data[index][''],
//                           );
//                         },
//                       );
//                     } else {
//                       return Container();
//                     }
//                   },
//                 ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
