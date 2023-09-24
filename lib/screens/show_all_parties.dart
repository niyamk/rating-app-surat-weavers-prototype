import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:surat_weavers_new/library.dart';
import 'package:surat_weavers_new/testing_screen.dart';
class ShowAllParties extends StatefulWidget {
  const ShowAllParties({Key? key}) : super(key: key);

  @override
  _ShowAllPartiesState createState() => _ShowAllPartiesState();
}

class _ShowAllPartiesState extends State<ShowAllParties> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(

        leading: BackButton(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rating').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data!.docs;
            if (data.isNotEmpty) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Get.to(
                            TestingRatingScreen(
                              companyName:
                                  data[index]['party_company_name'].toString(),
                              gstNo: data[index]['party_gst_no'].toString(),
                              mobile: data[index]['party_mobile'].toString(),
                              address: data[index]['party_address'].toString(),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(
                            data[index]['party_company_name']
                                .toString()
                                .capitalize!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 18),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 7),
                              Text('GST No : ' + data[index]['party_gst_no']),
                              SizedBox(height: 7),
                              Text('Mobile : ' + data[index]['party_mobile']),
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
                                    initialRating: data[index]['avg rating'],
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
                },
              );
            } else {
              return Text('');
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
