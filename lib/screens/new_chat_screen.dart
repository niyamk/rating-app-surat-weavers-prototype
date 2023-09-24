// import 'dart:developer';
// import 'dart:io';
//
// import 'package:uuid/uuid.dart';
// import 'package:bubble/bubble.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
//
// import 'package:csv/csv.dart';
// import 'dart:async' show Future;
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:grouped_list/grouped_list.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:surat_weavers_new/library.dart';
//
// class NewChatScreen extends StatefulWidget {
//   const NewChatScreen({super.key});
//
//   @override
//   State<NewChatScreen> createState() => _NewChatScreenState();
// }
//
// String user = '';
//
// class _NewChatScreenState extends State<NewChatScreen> {
//   /* void exportCsv() async {
//
//     final collection =
//     await FirebaseFirestore.instance.collection('MainPartyDataCenter');
//     final myData = await rootBundle.loadString('assets/PartyData.csv');
//     List csvTable = CsvToListConverter().convert(myData);
//     List data = [];
//     data = csvTable;
//
//     for(int i = 0 ; i < 403  ; i++){
//       print(data[i]);
//       if(data[i][3] != '' && data[i][2] != ''  ){
//         await FirebaseFirestore.instance
//             .collection('MainPartyDataCenter')
//             .doc(data[i][3].toString().toUpperCase())
//             .set({
//           'address': data[i][2].toString() ?? '',
//           'company_name': data[i][1].toString().capitalize ?? '',
//           'gst_no': data[i][3].toString().toUpperCase() ?? '',
//           'mobile': data[i][4].toString() ?? '',
//         });
//       }
//     }
//
//   }*/
//
//   var groupedListViewCtr = ScrollController(initialScrollOffset: 0.0);
//
//   final TextEditingController _message = TextEditingController();
//   String currentDate = DateFormat.yMMMd().format(DateTime.now());
//
//   File? imageFile;
//
//   Future getImage() async {
//     ImagePicker _picker = ImagePicker();
//     await _picker.pickImage(source: ImageSource.gallery).then((xfile) {
//       if (xfile != null) {
//         imageFile = File(xfile.path);
//         uploadImage();
//       }
//     });
//   }
//
//   Future uploadImage() async {
//     String fileName = Uuid().v1();
//
//     int status = 1;
//
//     var ref =
//     FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');
//
//     await FirebaseFirestore.instance
//         .collection('testGroupChat')
//         .doc(fileName)
//         .set({
//       'sendby': kFirebase.currentUser!.displayName,
//       'message': _message.text,
//       'type': 'img',
//       'time': DateFormat.jm().format(DateTime.now()),
//       'date': DateFormat.yMMMd().format(DateTime.now()),
//       'fulltime':DateTime.now(),
//     });
//
//     var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
//       await FirebaseFirestore.instance
//           .collection('testGroupChat')
//           .doc(fileName)
//           .delete();
//       status = 0;
//     });
//
//     if (status == 1) {
//       String imageUrl = await uploadTask.ref.getDownloadURL();
//       await FirebaseFirestore.instance
//           .collection('testGroupChat')
//           .doc(fileName)
//           .update(
//         {
//           'message': imageUrl,
//         },
//       );
//       log('phoenix >>>>>>>> ${imageUrl}');
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   void onSendMessage() async {
//     if (_message.text.isNotEmpty) {
//       Map<String, dynamic> messages = {
//         'sendby': kFirebase.currentUser!.displayName,
//         'message': _message.text,
//         'type': 'text',
//         'time': DateFormat.jm().format(DateTime.now()),
//         'date': DateFormat.yMMMd().format(DateTime.now()),
//         'fulltime':DateTime.now(),
//
//
//       };
//       await FirebaseFirestore.instance
//           .collection('testGroupChat')
//           .add(messages);
//       _message.clear();
//     } else {
//       print('Enter some text');
//     }
//   }
//
//   Future<bool> showExitPopup() async {
//     return await showDialog(
//       //show confirm dialogue
//       //the return value will be from "Yes" or "No" options
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Exit App'),
//         content: Text('Do you want to exit an App?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             //return false when click on "NO"
//             child: Text('No'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(true),
//             //return true when click on "Yes"
//             child: Text('Yes'),
//           ),
//         ],
//       ),
//     ) ??
//         false; //if showDialouge had returned null, then return false
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('phoenix --->>> ${DateTime.now()}');
//
//     return WillPopScope(
//       onWillPop: showExitPopup,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Group Chat '),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection('testGroupChat')
//                     .orderBy('time', descending: false)
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.hasData) {
//                     /*return ListView.builder(
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         return Text(
//                             snapshot.data!.docs[index]['message'].toString());
//                       },
//                     );*/
//
//                     var data = snapshot.data!.docs;
//                     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//                       groupedListViewCtr
//                           .jumpTo(groupedListViewCtr.position.maxScrollExtent);
//                     });
//                     return GroupedListView(
//                       controller: groupedListViewCtr,
//                       elements: snapshot.data!.docs,
//                       groupBy: (element) => element['date'],
//                       groupHeaderBuilder: (dynamic element) {
//                         var tempDate;
//                         print('current data = ${currentDate}');
//                         if (currentDate == element['date']) {
//                           tempDate = 'today';
//                         } else if ( DateFormat.yMMMd().format(DateTime.now()
//                             .subtract(Duration(days: 1)))  ==
//                             element['date']) {
//                           tempDate = 'yesterday';
//                         } else {
//                           tempDate = element['date'];
//                         }
//
//                         return SizedBox(
//                           height: 40,
//                           child: Center(
//                             child: Card(
//                               color: Colors.grey,
//
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8),
//                                 child: Text(
//                                   '${tempDate}',
//                                   style: const TextStyle(color: Colors.white),
//                                 ), // Text
//                               ), // Padding
//                             ),
//                           ),
//                         );
//                       },
//                       groupSeparatorBuilder: (value) {
//                         return SizedBox();
//                       },
//                       indexedItemBuilder: (context, element, index) {
//                         return Padding(
//                           padding: kFirebase.currentUser!.displayName ==
//                               data[index]['sendby']
//                               ? EdgeInsets.only(left: 30.w)
//                               : EdgeInsets.only(right: 30.w),
//                           child: Bubble(
//                             margin: BubbleEdges.only(top: 10),
//                             alignment: data[index]['sendby'] ==
//                                 kFirebase.currentUser!.displayName
//                                 ? Alignment.centerRight
//                                 : Alignment.centerLeft,
//                             color: data[index]['sendby'] ==
//                                 kFirebase.currentUser!.displayName
//                                 ? PhoenixThemeColor()
//                                 : Colors.white,
//                             nip: data[index]['sendby'] ==
//                                 kFirebase.currentUser!.displayName
//                                 ? BubbleNip.rightTop
//                                 : BubbleNip.leftTop,
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   data[index]['sendby'],
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: data[index]['sendby'] ==
//                                         kFirebase
//                                             .currentUser!.displayName
//                                         ? Colors.white
//                                         : PhoenixThemeColor(),
//                                     fontSize: 12.sp,
//                                   ),
//                                 ),
//                                 data[index]['type'] == 'text'
//                                     ?  Text(
//                                   data[index]['message'],
//                                   style: TextStyle(
//                                     color: data[index]['sendby'] ==
//                                         kFirebase
//                                             .currentUser!.displayName
//                                         ? Colors.white
//                                         : PhoenixThemeColor(),
//                                     fontSize: 12.sp,
//                                   ),
//                                 ) :  GestureDetector(
//                                   onTap: (){
//                                     return _showSecondPage(context, data[index]['message']);
//                                   },
//                                   child: Container(
//                                     child: data[index]['message'] != ''
//                                         ? Image.network(data[index]['message'],height: 30.h,width: 45.w,)
//                                         : CircularProgressIndicator(),
//                                   ),
//                                 ),
//                                 Text(
//                                   data[index]['time'],
//                                   style: TextStyle(color: Colors.grey),
//                                 ),
//                               ],
//                             ),
//                           ),
//
//                         );
//                       },
//                     );
//                   } else {
//                     return Container();
//                   }
//                 },
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
//                       child: Container(
//                         height: 50,
//                         child: TextField(
//                           controller: _message,
//                           decoration: InputDecoration(
//                             suffixIcon: IconButton(
//                                 onPressed: () => getImage(),
//                                 icon: Icon(Icons.photo_camera_outlined)),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: onSendMessage,
//                     child: CircleAvatar(
//                       maxRadius: 25,
//                       backgroundColor: PhoenixThemeColor(),
//                       child: Icon(
//                         Icons.send,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /*
// Container(
// height: 40.h,
// width: 50.w,
// alignment: data[index]['sendby'] ==
// kFirebase.currentUser!.displayName
// ? Alignment.centerRight
//     : Alignment.centerLeft,
// child: data[index]['message'] != ''
// ? Image.network(data[index]['message'])
//     : CircularProgressIndicator(),
// ),*/
//
// void _showSecondPage(BuildContext context,imageurl) {
//   Navigator.of(context).push(
//     MaterialPageRoute(
//       builder: (ctx) => Scaffold(
//         backgroundColor: Colors.cyan.withOpacity(.2),
//         body: Center(
//           child: Hero(
//             tag: 'my-hero-animation-tag',
//             child: Image.network(imageurl , height: 95.h , width: 95.w,),
//           ),
//         ),
//       ),
//     ),
//   );
// }


import 'dart:developer';
import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:csv/csv.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:grouped_list/grouped_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:surat_weavers_new/library.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

String user = '';

class _NewChatScreenState extends State<NewChatScreen> {
  /* void exportCsv() async {

    final collection =
    await FirebaseFirestore.instance.collection('MainPartyDataCenter');
    final myData = await rootBundle.loadString('assets/PartyData.csv');
    List csvTable = CsvToListConverter().convert(myData);
    List data = [];
    data = csvTable;

    for(int i = 0 ; i < 403  ; i++){
      print(data[i]);
      if(data[i][3] != '' && data[i][2] != ''  ){
        await FirebaseFirestore.instance
            .collection('MainPartyDataCenter')
            .doc(data[i][3].toString().toUpperCase())
            .set({
          'address': data[i][2].toString() ?? '',
          'company_name': data[i][1].toString().capitalize ?? '',
          'gst_no': data[i][3].toString().toUpperCase() ?? '',
          'mobile': data[i][4].toString() ?? '',
        });
      }
    }

  }*/

  var groupedListViewCtr = ScrollController(initialScrollOffset: 0.0);

  final TextEditingController _message = TextEditingController();
  String currentDate = DateFormat.yMMMd().format(DateTime.now());

  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xfile) {
      if (xfile != null) {
        imageFile = File(xfile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();

    int status = 1;

    var ref =
    FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');

    await FirebaseFirestore.instance
        .collection('testGroupChat')
        .doc(fileName)
        .set({
      'sendby': kFirebase.currentUser!.displayName,
      'message': _message.text,
      'type': 'img',
      'time': DateTime.now(),

    });

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await FirebaseFirestore.instance
          .collection('testGroupChat')
          .doc(fileName)
          .delete();
      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('testGroupChat')
          .doc(fileName)
          .update(
        {
          'message': imageUrl,
        },
      );
      log('phoenix >>>>>>>> ${imageUrl}');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'sendby': kFirebase.currentUser!.displayName,
        'message': _message.text,
        'type': 'text',
        'time': DateTime.now(),



      };
      await FirebaseFirestore.instance
          .collection('testGroupChat')
          .add(messages);
      _message.clear();
    } else {
      print('Enter some text');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    print('phoenix --->>> ${DateTime.now()}');

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Group Chat '),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('testGroupChat')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    /*return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Text(
                            snapshot.data!.docs[index]['message'].toString());
                      },
                    );*/

                    var data = snapshot.data!.docs;
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      groupedListViewCtr
                          .jumpTo(groupedListViewCtr.position.maxScrollExtent);
                    });
                    return GroupedListView(
                      controller: groupedListViewCtr,
                      elements: snapshot.data!.docs,
                      groupBy: (element) => DateTime.fromMicrosecondsSinceEpoch(element['time'].microsecondsSinceEpoch).toString().split(' ')[0],
                      groupHeaderBuilder: (dynamic element) {
                        var tempDate;
                        print('current data = ${currentDate}');
                        if (currentDate == DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(element['time'].microsecondsSinceEpoch)) ) {
                          tempDate = 'today';
                        } else if ( DateFormat.yMMMd().format(DateTime.now()
                            .subtract(Duration(days: 1)))  ==
                            DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(element['time'].microsecondsSinceEpoch))  ) {
                          tempDate = 'yesterday';
                        } else {
                          tempDate = DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(element['time'].microsecondsSinceEpoch));
                        }

                        return SizedBox(
                          height: 40,
                          child: Center(
                            child: Card(
                              color: Colors.grey,

                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  '${tempDate}',
                                  style: const TextStyle(color: Colors.white),
                                ), // Text
                              ), // Padding
                            ),
                          ),
                        );
                      },
                      groupSeparatorBuilder: (value) {
                        return SizedBox();
                      },
                      indexedItemBuilder: (context, element, index) {
                        return Padding(
                          padding: kFirebase.currentUser!.displayName ==
                              data[index]['sendby']
                              ? EdgeInsets.only(left: 30.w)
                              : EdgeInsets.only(right: 30.w),
                          child: Bubble(
                            margin: BubbleEdges.only(top: 10),
                            alignment: data[index]['sendby'] ==
                                kFirebase.currentUser!.displayName
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            color: data[index]['sendby'] ==
                                kFirebase.currentUser!.displayName
                                ? PhoenixThemeColor()
                                : Colors.white,
                            nip: data[index]['sendby'] ==
                                kFirebase.currentUser!.displayName
                                ? BubbleNip.rightTop
                                : BubbleNip.leftTop,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index]['sendby'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: data[index]['sendby'] ==
                                        kFirebase
                                            .currentUser!.displayName
                                        ? Colors.white
                                        : PhoenixThemeColor(),
                                    fontSize: 12.sp,
                                  ),
                                ),
                                data[index]['type'] == 'text'
                                    ?  Text(
                                  data[index]['message'],
                                  style: TextStyle(
                                    color: data[index]['sendby'] ==
                                        kFirebase
                                            .currentUser!.displayName
                                        ? Colors.white
                                        : PhoenixThemeColor(),
                                    fontSize: 12.sp,
                                  ),
                                ) :  GestureDetector(
                                  onTap: (){
                                    return _showSecondPage(context, data[index]['message']);
                                  },
                                  child: Container(
                                    child: data[index]['message'] != ''
                                        ? Image.network(data[index]['message'],height: 30.h,width: 45.w,)
                                        : CircularProgressIndicator(),
                                  ),
                                ),
                                Text(
                                  DateFormat.jm().format( DateTime.fromMicrosecondsSinceEpoch(data[index]['time'].microsecondsSinceEpoch)) ,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),

                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      child: Container(
                        height: 50,
                        child: TextField(
                          controller: _message,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () => getImage(),
                                icon: Icon(Icons.photo_camera_outlined)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onSendMessage,
                    child: CircleAvatar(
                      maxRadius: 25,
                      backgroundColor: PhoenixThemeColor(),
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
Container(
height: 40.h,
width: 50.w,
alignment: data[index]['sendby'] ==
kFirebase.currentUser!.displayName
? Alignment.centerRight
    : Alignment.centerLeft,
child: data[index]['message'] != ''
? Image.network(data[index]['message'])
    : CircularProgressIndicator(),
),*/

void _showSecondPage(BuildContext context,imageurl) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (ctx) => Scaffold(
        backgroundColor: Colors.cyan.withOpacity(.2),
        body: Center(
          child: Hero(
            tag: 'my-hero-animation-tag',
            child: Image.network(imageurl , height: 95.h , width: 95.w,),
          ),
        ),
      ),
    ),
  );
}