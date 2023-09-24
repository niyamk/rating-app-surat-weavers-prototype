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

late String currentGstNo;
var _data;

class _TestingRatingScreenState extends State<TestingRatingScreen> {
  double mainRating = 0;
  Map<String, dynamic>? whoRated;
  // late double avgRating;
  Map? whoCommented;
  String? prevComment;
  final commentController = TextEditingController();

  Future getData() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docsnap = await collection.doc(kFirebase.currentUser!.uid).get();
    if (docsnap.exists) {
      setState(() {
        Map<String, dynamic>? data = docsnap.data();
        currentGstNo = data?['gst_no'];
      });
    }
  }

  Future ratingDetails() async {
    var docSnaps = await FirebaseFirestore.instance
        .collection('rating')
        .doc(widget.gstNo)
        .get();
    if (docSnaps.exists) {
      _data = docSnaps.data();
      setState(() {
        mainRating = _data['who rated'][currentGstNo.toString()] ?? 0;
        whoRated = _data['who rated'] ?? {};
        whoCommented = _data['comments'] ?? {};
        if (_data[currentGstNo] != null) {
          prevComment = _data['comments'][currentGstNo]['rating part'] ?? "";
        } else {
          prevComment = '-no comment-';
        }
        /*if(prevComment != "" && prevComment != '-no comment-' ){
       commentController.text = prevComment! ;
     }*/
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
      backgroundColor: Colors.green.shade900,
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          color: Colors.green,
          image: DecorationImage(
              image: AssetImage('assets/images/green_bg.jpg'),
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth),
        ),
        child: Column(
          children: [
            Container(
              height: 15.h,
              width: 100.w,
              // padding: EdgeInsets.all(5.w),
              // child: Image.asset('assets/images/green_bg.avif',
              //     fit: BoxFit.fitWidth),
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              height: 85.h,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Map totalWhoCommented = {
                              ...whoCommented!,
                              ...{
                                currentGstNo: {
                                  'date of edit': DateFormat('dd-MM-yyyy')
                                      .format(DateTime.now())
                                      .toString(),
                                  'rating part': commentController.text
                                          .toString()
                                          .trim()
                                          .isNotEmpty
                                      ? commentController.text.toString()
                                      : prevComment ?? '-no comment-',
                                  'rating star': mainRating,
                                }
                              },
                            };

                            // log('total who commented >> $totalWhoCommented');

                            Map totalWhoRated = {
                              ...whoRated!,
                              ...{
                                currentGstNo: mainRating,
                              },
                            };

                            double avgRatingAfterTotal = ((totalWhoRated.values
                                    .toList()
                                    .reduce(
                                        (value, element) => value + element)) /
                                (whoRated!.isEmpty
                                    ? 1
                                    : whoRated!.keys.contains(currentGstNo)
                                        ? whoRated!.length
                                        : whoRated!.length + 1));

                            FirebaseFirestore.instance
                                .collection('rating')
                                .doc(widget.gstNo)
                                .update({
                              'who rated': totalWhoRated,
                              'avg rating': avgRatingAfterTotal,
                              'comments': totalWhoCommented,
                            }).whenComplete(() => Get.back());
                          },
                          child: Text('Save')),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: onEdit,
                        child: Text('Edit'),
                      ),
                      if (kFirebase.currentUser!.email == 'niyam4103@gmail.com')
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Are you Sure?'),
                                      actions: [
                                        OutlinedButton(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance
                                                  .collection('rating')
                                                  .doc(widget.gstNo)
                                                  .update({
                                                'comments': {},
                                                'who rated': {},
                                                'avg rating': 0.0,
                                              }).then((value) => Get.back());
                                            },
                                            child: Text('Yes')),
                                        OutlinedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text('No')),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text('Reset')),
                        )
                      else
                        SizedBox(),
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
                  Center(
                    child: Text('- comments and reviews -'),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('rating')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      List currentCommentData = [];
                      List currentCommentKey = [];
                      List ratingList = [];

                      log('----- phoenix ${whoCommented == null ? 'yes its null' : 'no it aint null'}}');

                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount:
                                whoCommented != null ? whoCommented!.length : 0,
                            itemBuilder: (context, index) {
                              String whoCommentedGstNo =
                                  whoCommented!.keys.toList()[index];
                              // log('-----hail phoenix >> ${whoCommented![whoCommented!.keys.toList()[index]]['rating star']}');
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          '${whoCommented!.keys.toList()[index].toString().substring(0, 5)}**********',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15)),
                                      RatingBar.builder(
                                        itemSize: 17,
                                        allowHalfRating: true,
                                        glow: false,
                                        ignoreGestures: true,
                                        initialRating: whoCommented != null
                                            ? double.parse(
                                                whoCommented![whoCommentedGstNo]
                                                        ['rating star']
                                                    .toString())
                                            : 0,
                                        itemCount: 5,
                                        onRatingUpdate: (double value) {},
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          '${whoCommented![whoCommentedGstNo]['rating part']}'),
                                      Text(
                                          '(${whoCommented![whoCommentedGstNo]['date of edit']})'),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                ],
                              );
                            },
                          ),
                        );
                      } else {
                        return Container();
                      }

                      // if (snapshot.hasData) {
                      //   List data = snapshot.data!.docs;
                      //   for (int i = 0; i < data.length; i++) {
                      //     if (data[i]['party_gst_no'] == '${widget.gstNo}') {
                      //       // log(' ------ susscess ${data[i]['comments']}');
                      //       currentCommentKey = data[i]['comments'].keys.toList();
                      //       currentCommentData =
                      //           data[i]['comments'].values.toList();
                      //       ratingList = data[i]['who rated'].values.toList();
                      //       // log('current common data ${whoCommented}');
                      //
                      //       log('-------------- noice');
                      //       break;
                      //     }
                      //   }
                      //   return Expanded(
                      //     child: ListView.builder(
                      //       itemCount: currentCommentData.length,
                      //       itemBuilder: (BuildContext context, int index) {
                      //         return ListTile(
                      //           title: Text(currentCommentKey[index]),
                      //
                      //         );
                      //       },
                      //     ),
                      //   );
                      // } else {
                      //   return Container();
                      // }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  onEdit() {
    FocusManager.instance.primaryFocus?.unfocus();
    final editTextController = TextEditingController();
    List typeList = ['Company Name', 'Address', 'Mobile no.'];
    List adminTypeList = [ 'party_company_name' , 'party_address' , 'party_mobile'];
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
              Text('Current Company Name :- ${widget.companyName}'),
              Text('Current Address :- ${widget.address}'),
              Text('Current Mobile no. :- ${widget.mobile}'),
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
                            title: Text('Enter correct ${typeList[index]}'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /*Text(
                                                        'Old ${typeList[index]} :- ${typeListWithDetails[index]}'),*/
                                SizedBox(height: 10),
                                TextField(
                                  controller: editTextController,
                                  decoration:
                                      InputDecoration(hintText: 'enter here'),
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
                                  onPressed: () async {
                                    // log('${editTextController.text.trim() == typeListWithDetails[index]}');
                                    if (editTextController.text.isNotEmpty ) {
                                      // launch(
                                      //     'https://wa.me/+91 9727872141?text= { ${widget.gstNo} } *${typeList[index]}* OLD ~${typeListWithDetails[index]}~ - *NEW* _${editTextController.text}_');

                                      await FirebaseFirestore.instance
                                          .collection('EditRequest')
                                          .doc('${currentGstNo}-${widget.gstNo}')
                                          .set({
                                        'editor': currentGstNo,
                                        'being edited' : widget.gstNo,
                                        'type_of_edit': adminTypeList[index],
                                        'old_entry': typeListWithDetails[index],
                                        'new_entry': editTextController.text.trim(),
                                      });
                                    }
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Send Request')),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border:
                            Border.all(color: PhoenixThemeColor(), width: 2),
                      ),
                      child: ListTile(
                        title: Text(
                          typeList[index],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_sharp),
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
  }
}
