import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:surat_weavers_new/library.dart';
import 'dart:developer';



class RatingBroker extends StatefulWidget {
  const RatingBroker({
    Key? key,
    this.brokerId,
    this.brokerName,
    this.brokerMobile1,
    this.brokerMobile2,
  }) : super(key: key);

  @override
  _RatingBrokerState createState() => _RatingBrokerState();
  final brokerId;
  final brokerName;
  final brokerMobile1;
  final brokerMobile2;
}

late var value;
late var Gstvalue;
var _data;

class _RatingBrokerState extends State<RatingBroker> {
  double mainRating = 0;
  late Map<String, dynamic> whoRatedData;
  late double avgRating;
  late Map whoCommented;
  Map? prevComment;
  final commentController = TextEditingController();
  final GlobalKey<ScaffoldState> globalKey = GlobalKey();

  Future GetData() async {
    var collection = FirebaseFirestore.instance.collection('brokers');
    var docsnap = await collection.doc(widget.brokerId).get();
    if (docsnap.exists) {
      setState(() {
        Map<String, dynamic>? data = docsnap.data();
        value = data?['broker_id'];
        log('---------------$value-------------------');
      });
    }
  }

  Future GetGstOfWhoRated() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docsnap = await collection.doc('${kFirebase.currentUser!.uid}').get();
    if (docsnap.exists) {
      setState(() {
        Map<String, dynamic>? data = docsnap.data();
        Gstvalue = data?['gst_no'];
        log('PHOENIXXXXXXXXXXXXXXXXXXXXXXXXXXX ${kFirebase.currentUser!.uid}');
      });
    }
  }

  Future getRatingDetail() async {
    var collection = FirebaseFirestore.instance.collection('brokers');
    var docsnap = await collection.doc('${widget.brokerId}').get();
    if (docsnap.exists) {
      _data = docsnap.data();
      setState(() {
        mainRating = _data['who rated']['$Gstvalue'] ?? 0;
      });

      whoRatedData = _data['who rated'];
      whoCommented = _data['comments'];
      // log('--------who commented ${_data['comments']}');
      // log('------------type of data[comments][values] ${_data['comments']['$value']}');
      prevComment = _data['comments']['$value'];
      // log('------init rating $mainRating');
    }
  }

  @override
  void initState() {
    GetData()
        .then((value) => GetGstOfWhoRated().then((value) => getRatingDetail()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(),
      body: SafeArea(
        // ignore: sized_box_for_whitespace
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                widget.brokerName,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                widget.brokerMobile1,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                widget.brokerMobile2,
                style: TextStyle(fontSize: 20),
              ),
              RatingBar.builder(
                allowHalfRating: true,
                glow: false,
                initialRating: mainRating,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (double value) {
                  log(value.toString());
                  setState(() {
                    mainRating = value;
                  });
                },
              ),

              ElevatedButton(
                  onPressed: () async {
                    Map totalWhoCommented = {
                      ...whoCommented,
                      ...{
                        '$Gstvalue': {
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
                    log('testing save button');

                    Map totalWhoRated = {
                      ...whoRatedData,
                      ...{'$Gstvalue': mainRating},
                    };
                    double avgRatingAfterTotal = ((totalWhoRated.values
                            .toList()
                            .reduce((value, element) => value + element)) /
                        (whoRatedData.isEmpty
                            ? 1
                            : whoRatedData.keys.contains(Gstvalue)
                                ? whoRatedData.length
                                : whoRatedData.length + 1));
                    log('-----initital rating${whoRatedData.length}   and total ${avgRatingAfterTotal}');

                    FirebaseFirestore.instance
                        .collection('brokers')
                        .doc(widget.brokerId)
                        .set({
                      'who rated': totalWhoRated,
                      'broker_name': widget.brokerName,
                      'broker_mobile_1': widget.brokerMobile1,
                      'broker_mobile_2': widget.brokerMobile2,
                      'broker_id': widget.brokerId,
                      'avg rating': double.parse(
                          (avgRatingAfterTotal.toStringAsFixed(2))),
                      'comments': totalWhoCommented,
                    });
                    Get.off(
                      HomeScreen(),
                    );
                  },
                  child: Text('save')),

              // ElevatedButton(
              //   onPressed: () {
              //     final editTextController = TextEditingController();
              //     List typeList = ['Company Name', 'Address', 'Mobile no.'];
              //     List typeListWithDetails = [
              //       widget.companyName,
              //       widget.address,
              //       widget.mobile
              //     ];
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return AlertDialog(
              //           title: Text('Select what you want to edit'),
              //           content: Column(
              //             mainAxisSize: MainAxisSize.min,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Text(
              //                   'Current Company Name :- ${widget.companyName}'),
              //               Text('Current Address :- ${widget.address}'),
              //               Text('Current Mobile no. :- ${widget.mobile}'),
              //               SizedBox(height: 10),
              //               Column(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: List.generate(
              //                   typeList.length,
              //                   (index) => GestureDetector(
              //                     onTap: () {
              //                       showDialog(
              //                         context: context,
              //                         builder: (BuildContext context) {
              //                           return AlertDialog(
              //                             title: Text(
              //                                 'Enter correct ${typeList[index]}'),
              //                             content: Column(
              //                               mainAxisSize: MainAxisSize.min,
              //                               children: [
              //                                 /*Text(
              //                                     'Old ${typeList[index]} :- ${typeListWithDetails[index]}'),*/
              //                                 SizedBox(height: 10),
              //                                 TextField(
              //                                   controller:
              //                                       editTextController,
              //                                   decoration: InputDecoration(
              //                                       hintText: 'enter here'),
              //                                 ),
              //                               ],
              //                             ),
              //                             actions: [
              //                               OutlinedButton(
              //                                   onPressed: () {
              //                                     Navigator.pop(context);
              //                                   },
              //                                   child: Text('cancel')),
              //                               OutlinedButton(
              //                                   onPressed: () {
              //                                     if (editTextController
              //                                         .text.isNotEmpty) {
              //                                       launch(
              //                                           'https://wa.me/+91 9727872141?text= { ${widget.gstNo} } *${typeList[index]}* OLD ~${typeListWithDetails[index]}~ - *NEW* _${editTextController.text}_');
              //                                     }
              //                                     Navigator.pop(context);
              //                                     Navigator.pop(context);
              //                                   },
              //                                   child: Text(
              //                                       'send through Whatsapp')),
              //                             ],
              //                           );
              //                         },
              //                       );
              //                     },
              //                     child: Container(
              //                       margin: EdgeInsets.only(bottom: 10),
              //                       decoration: BoxDecoration(
              //                         borderRadius: BorderRadius.all(
              //                             Radius.circular(10)),
              //                         border: Border.all(
              //                             color: PhoenixThemeColor(),
              //                             width: 2),
              //                       ),
              //                       child: ListTile(
              //                         title: Text(
              //                           typeList[index],
              //                         ),
              //                         trailing: Icon(
              //                             Icons.arrow_forward_ios_sharp),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //           actions: [
              //             OutlinedButton(
              //                 onPressed: () {
              //                   Navigator.pop(context);
              //                 },
              //                 child: Text('cancel'))
              //           ],
              //         );
              //       },
              //     );
              //   },
              //   child: Text('Edit'),
              // ),

              SizedBox(height: 10),
              TextField(
                controller: commentController,
                maxLines: 4,
                minLines: 1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'comment (optional)',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 2,
                      color: PhoenixThemeColor(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('- comments and reviews - '),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('brokers')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  List currentCommentData = [];
                  List currentCommentKey = [];
                  List ratingList = [];
                  if (snapshot.hasData) {
                    List data = snapshot.data!.docs;

                    for (int i = 0; i < data.length; i++) {
                      if (data[i]['broker_id'] == '${widget.brokerId}') {
                        // log(' ------ susscess ${data[i]['comments']}');
                        currentCommentKey = data[i]['comments'].keys.toList();
                        currentCommentData =
                            data[i]['comments'].values.toList();
                        ratingList = data[i]['who rated'].values.toList();
                        // log('current common data ${whoCommented}');
                        break;
                      }
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: currentCommentData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${currentCommentKey[index].toString().substring(0, 2)}**********' +
                                  '     ' +
                                  '${currentCommentData[index]['date of edit']}'),
                              RatingBar.builder(
                                itemSize: 17,
                                allowHalfRating: true,
                                glow: false,
                                ignoreGestures: true,
                                initialRating: ratingList[index],
                                itemCount: 5,
                                onRatingUpdate: (double value) {},
                                itemBuilder: (BuildContext context, int index) {
                                  return Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  );
                                },
                              ),
                              Text(
                                  '${currentCommentData[index]['rating part']}'),
                              SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
