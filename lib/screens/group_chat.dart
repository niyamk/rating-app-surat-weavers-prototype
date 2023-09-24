import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:bubble/bubble.dart';
import 'package:surat_weavers_new/library.dart';
class GroupChat extends StatefulWidget {
  const GroupChat({Key? key}) : super(key: key);

  @override
  _GroupChatState createState() => _GroupChatState();
}

var _currentUsersGstNo;
var _currentUsersName;
int? _lengthOfData;
List? _listOfData;

class _GroupChatState extends State<GroupChat> {
  final _textController = TextEditingController();
  final _globalKey = GlobalKey<ScaffoldState>();
  String currentDate = DateTime.now().toString().split(' ')[0];

  var groupedListViewCtr = ScrollController(initialScrollOffset: 0.0);

  Future GetData() async {
    var dataX = await FirebaseFirestore.instance
        .collection('users')
        .doc('${kFirebase.currentUser!.uid}')
        .get();
    if (dataX.exists) {
      setState(() {
        Map<String, dynamic>? data = dataX.data();
        _currentUsersGstNo = data?['gst_no'];
      });
    }
  }

  Future GetListData() async {
    var ListData = await FirebaseFirestore.instance
        .collection('chat')
        .doc('groupChatData')
        .get();
    if (ListData.exists) {
      setState(() {
        Map? data2 = ListData.data();
        _listOfData = data2!['list of Data'];
        // log('------ list of data ${_listOfData} and data ${data2} and ${data2['list of Data']}');
      });
    }
  }

  Future GetSharedPrefData() async {
    String? data = await SharedPrefService.getUsername();
    setState(() {
      _currentUsersName = data ?? '--name not found--';
    });
    // log('---------- Phoenix this is your data ${_currentUsersName}');
  }

  @override
  void initState() {
    super.initState();
    GetData();
    GetSharedPrefData();
    GetListData();
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


    // if (_controller.hasClients) {
    //   _controller.jumpTo(_controller.position.maxScrollExtent);
    // }
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        // key: _globalKey,
        /*drawer: Drawer(
          child: SafeArea(
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
                        ? kFirebase.currentUser!.displayName
                            .toString()
                            .capitalize!
                        : 'try rejoin',
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                InkWell(
                  onTap: () {
                    signOutGoogle();
                    SharedPrefService.logOut();
                    Get.off(SignUpScreen());
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
              ],
            ),
          ),
        ),*/
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => gglobalKey.currentState!.openDrawer(),
            icon: Icon(Icons.menu),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.group_outlined),
              Text('Group Chat'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Expanded(child: SizedBox()),

            /// STREAM BUILDER
            /*Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firebaseFirestore.collection('chat').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    // var data = snapshot.data!.docs[0]['list of Data'];
                    // _lengthOfData = data.length;
                    log('-----------------${_listOfData}');
                    if (_listOfData != null) {
                      return ListView.builder(
                        itemCount: _listOfData!.length,
                        itemBuilder: (BuildContext context, int index) {
                          // List currentData = _listOfData![index];
                          return Bubble(
                            margin: BubbleEdges.only(top: 10),
                            alignment:
                                _listOfData![index]['sender'] == _currentUsersName
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            color:
                                _listOfData![index]['sender'] == _currentUsersName
                                    ? PhoenixThemeColor()
                                    : Colors.white,
                            child: Text(
                              _listOfData![index]['text'],
                              style: TextStyle(
                                color: _listOfData![index]['sender'] ==
                                        _currentUsersName
                                    ? Colors.white
                                    : PhoenixThemeColor(),
                                fontSize: 12.sp,
                              ),
                            ),
                            nip:
                                _listOfData![index]['sender'] == _currentUsersName
                                    ? BubbleNip.rightTop
                                    : BubbleNip.leftTop,
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                    */ /*return ListView.builder(
                      itemCount: data.length,
                      controller: _controller,
                      // reverse: true,
                      itemBuilder: (context, index) {
                        List MainData = data[0][''];
                        return ListTile(
                            // title: Text('${data[index]['who_texted']}'),
                            // subtitle: Text('${data[index]['text_of_post']}'),
                            );
                      },
                    );*/ /*
                  } else {
                    return Container();
                  }
                },
              ),
            ),*/

            /// testing
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firebaseFirestore.collection('chat').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (_listOfData == null) {
                      _listOfData = [];
                    }
                    print(snapshot.data!.docs);
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      groupedListViewCtr
                          .jumpTo(groupedListViewCtr.position.maxScrollExtent);
                    });
                    /*_listOfData!.sort((a, b) {
                      return a['testing']
                          .toString()
                          .compareTo(b['testing'].toString());
                    });*/

                    return GroupedListView(
                      // reverse: false,
                      controller: groupedListViewCtr,
                      // floatingHeader: false,
                      // sort: true,
                      // itemExtent: groupedListViewCtr.position.maxScrollExtent,
                      elements: _listOfData!,
                      groupBy: (dynamic element) => element['testing'],
                      groupHeaderBuilder: (dynamic date) {
                        var tempDate;
                        if (currentDate == date['testing']) {
                          tempDate = 'today';
                        } else if (DateTime.now()
                                .subtract(Duration(days: 1))
                                .toString()
                                .split(' ')[0] ==
                            date['testing']) {
                          tempDate = 'yesterday';
                        } else {
                          tempDate = date['testing'];
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
                      groupSeparatorBuilder: (time) => SizedBox(),
                      itemBuilder: (context, dynamic data) => Padding(
                        padding: _currentUsersName == data['sender']
                            ? EdgeInsets.only(left: 30.w)
                            : EdgeInsets.only(right: 30.w),
                        child: Bubble(
                          margin: BubbleEdges.only(top: 10),
                          // ignore: sort_child_properties_last
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['sender'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: data['sender'] == _currentUsersName
                                      ? Colors.white
                                      : PhoenixThemeColor(),
                                  fontSize: 12.sp,
                                ),
                              ),
                              Text(
                                data['text'],
                                style: TextStyle(
                                  color: data['sender'] == _currentUsersName
                                      ? Colors.white
                                      : PhoenixThemeColor(),
                                  fontSize: 12.sp,
                                ),
                              ),
                              Text(
                                data['when_sent'],
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          alignment: data['sender'] == _currentUsersName
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          color: data['sender'] == _currentUsersName
                              ? PhoenixThemeColor()
                              : Colors.white,
                          nip: data['sender'] == _currentUsersName
                              ? BubbleNip.rightTop
                              : BubbleNip.leftTop,
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),

            ///
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50.sp,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: TextField(
                          controller: _textController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GestureDetector(
                        onTap: () async {
                          setState(() async {
                            if (_textController.text.isNotEmpty) {
                              String tempVar = _textController.text;
                              String currentDate =
                                  DateTime.now().toString().split(' ')[0];
                              _textController.clear();
                              _listOfData!.add({
                                'text': tempVar,
                                'sender': _currentUsersName,
                                'when_sent':
                                    DateFormat.jm().format(DateTime.now()),
                                'time': DateFormat.yMMMd().format(DateTime.now()),
                                'testing': currentDate,
                                // 'when_sent':
                                //     DateFormat.jm(DateTime.now()).toString(),
                              });
                              // _listOfData!.removeLast();
                              // log(' hello phoenix  ${_listOfData![4]}');
                              // log('--------NEW LIST ++++ ${_listOfData}');
                              await firebaseFirestore
                                  .collection('chat')
                                  .doc('groupChatData')
                                  .set({
                                'list of Data': _listOfData,
                              }) /*.then((value) => _textController.clear())*/;

                              // FocusManager.instance.primaryFocus?.unfocus();
                            }
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: PhoenixThemeColor(),
                          ),
                          child: Image.asset(
                            'assets/images/paper-plane.png',
                            height: 12.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
