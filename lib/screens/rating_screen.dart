import 'dart:developer';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:surat_weavers_new/library.dart';
import 'package:url_launcher/url_launcher.dart';
class RatingScreen extends StatefulWidget {
  const RatingScreen({
    Key? key,
    this.companyName,
    this.gstNo,
    this.mobile,
    this.address,
  }) : super(key: key);

  @override
  _RatingScreenState createState() => _RatingScreenState();
  final companyName;
  final gstNo;
  final mobile;
  final address;
}

late var value;
var _data;

class _RatingScreenState extends State<RatingScreen> {
  double mainRating = 0;
  late Map<String, dynamic> whoRatedData;
  late double avgRating;
  late Map whoCommented;
  String? prevComment;
  final commentController = TextEditingController();

  // ignore: non_constant_identifier_names
  Future GetData() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docsnap = await collection.doc(kFirebase.currentUser!.uid).get();
    if (docsnap.exists) {
      setState(() {
        Map<String, dynamic>? data = docsnap.data();
        value = data?['gst_no'];
        log('---------------$value-------------------');
      });
    }
  }

  Future getRatingDetail() async {
/*var collection = FirebaseFirestore.instance
        .collection('rating')
        .doc('${widget.gstNo}')
        .collection('who rated');
    var docsnap = await collection.doc('${value}').get();
    if (docsnap.exists) {
      setState(() {
        data = docsnap.data();
        print('hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii');
        log('---------------------------------------------------');
        mainRating = data?['rating'];
      });
    } else {
      print('byeeeeeeeeeeeeeeeeeeeeeeeeee');
      log('-----rated guy ${widget.gstNo}');
    }*/
    var collection = FirebaseFirestore.instance.collection('rating');
    var docsnap = await collection.doc('${widget.gstNo}').get();
    if (docsnap.exists) {
      _data = docsnap.data();
      setState(() {
        mainRating = _data['who rated']['$value'] ?? 0;
      });

      whoRatedData = _data['who rated'];
      whoCommented = _data['comments'];
      log('--------who commented ${_data['comments']}');
      prevComment = _data['comments']['$value'];
      log('------ whocommented $whoCommented');
      // if (whoRatedData.isNotEmpty) {
      // var ratingValues = whoRatedData.values.toList();
      // log('incoming data ---- ${ratingValues.reduce((value, element) => value + element)} and avg rating --- $avgRating');
      // }
    }
  }

  /*// ignore: non_constant_identifier_names
  Future GetAvgRating() async {
    var collection = FirebaseFirestore.instance.collection('rating');
    var docsnap = await collection.doc('${widget.gstNo}').get();
    if (docsnap.exists) {
      data = docsnap.data();
      whoCommented = data['comments'];
      whoRatedData = data['who rated'];
      double totalRating = whoRatedData.values
          .toList()
          .reduce((value, element) => value + element);
      double avgRating = totalRating / whoRatedData.length;
      FirebaseFirestore.instance
          .collection('rating')
          .doc(widget.gstNo.toString())
          .set({
        'who rated': whoRatedData,
        'party_address': widget.address,
        'party_company_name': widget.companyName,
        'party_gst_no': widget.gstNo,
        'party_mobile': widget.mobile,
        'avg rating': avgRating,
        'comments': whoCommented,
      });
      log('-------$whoRatedData $avgRating data >>>>>>> $data');
    }
  }*/

  @override
  void dispose() {
    log('rating screen went off');
    // GetAvgRating();
    super.dispose();
  }

  @override
  void initState() {
    GetData().then((value) => getRatingDetail());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('------------------- rating screen ${widget.companyName} ');
    return Scaffold(
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
                widget.companyName,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                widget.gstNo,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                widget.mobile,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                widget.address,
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
              Row(
                children: [
                  Spacer(flex: 8),
                  ElevatedButton(
                      onPressed: () async {
                        Map totalWhoCommented = {
                          ...whoCommented,
                          ...{

                            '$value': {
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
                          ...{'$value': mainRating},
                        };
                        double avgRatingAfterTotal = ((totalWhoRated.values
                                .toList()
                                .reduce((value, element) => value + element)) /
                            (whoRatedData.isEmpty
                                ? 1
                                : whoRatedData.keys.contains(value)
                                    ? whoRatedData.length
                                    : whoRatedData.length + 1));
                        log('-----initital rating${whoRatedData.length}   and total ${avgRatingAfterTotal}');

                        FirebaseFirestore.instance
                            .collection('rating')
                            .doc(widget.gstNo.toString())
                            .set({
                          'who rated': totalWhoRated,
                          'party_address': widget.address,
                          'party_company_name': widget.companyName,
                          'party_gst_no': widget.gstNo,
                          'party_mobile': widget.mobile,
                          'avg rating': double.parse(
                              (avgRatingAfterTotal.toStringAsFixed(2))),
                          'comments': totalWhoCommented,
                        });
                        Get.off(
                          HomeScreen(),
                        );
                      },
                      child: Text('save')),
                  Spacer(flex: 1),
                  ElevatedButton(
                    onPressed: () {
                      final editTextController = TextEditingController();
                      List typeList = ['Company Name', 'Address', 'Mobile no.'];
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
                                              title: Text(
                                                  'Enter correct ${typeList[index]}'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  /*Text(
                                                      'Old ${typeList[index]} :- ${typeListWithDetails[index]}'),*/
                                                  SizedBox(height: 10),
                                                  TextField(
                                                    controller:
                                                        editTextController,
                                                    decoration: InputDecoration(
                                                        hintText: 'enter here'),
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
                                                            'https://wa.me/+91 9727872141?text= { ${widget.gstNo} } *${typeList[index]}* OLD ~${typeListWithDetails[index]}~ - *NEW* _${editTextController.text}_');
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
                stream:
                    FirebaseFirestore.instance.collection('rating').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  List currentCommentData = [];
                  List currentCommentKey = [];
                  List ratingList = [];
                  if (snapshot.hasData) {
                    List data = snapshot.data!.docs;

                    for (int i = 0; i < data.length; i++) {
                      if (data[i]['party_gst_no'] == '${widget.gstNo}') {
                        // log(' ------ susscess ${data[i]['comments']}');
                        currentCommentKey = data[i]['comments'].keys.toList();
                        currentCommentData =
                            data[i]['comments'].values.toList();
                        ratingList = data[i]['who rated'].values.toList();
                        // log('current common data ${whoCommented}');

                        log('-------------- noice');
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
