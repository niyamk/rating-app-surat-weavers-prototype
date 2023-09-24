import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:surat_weavers_new/library.dart';
import 'package:surat_weavers_new/screens/rating_broker.dart';
class ShowAllBrokers extends StatefulWidget {
  const ShowAllBrokers({Key? key}) : super(key: key);

  @override
  _ShowAllBrokersState createState() => _ShowAllBrokersState();
}

class _ShowAllBrokersState extends State<ShowAllBrokers> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('brokers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
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
                          mainAxisSize: MainAxisSize.min,
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
                                Text('( ${data[index]['who rated'].length} )'),
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
                            SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: 10),
                    Divider(),
                  ],
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
