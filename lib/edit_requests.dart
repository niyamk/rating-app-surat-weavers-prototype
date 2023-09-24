import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:surat_weavers_new/library.dart';

class EditReqScreen extends StatefulWidget {
  const EditReqScreen({super.key});

  @override
  State<EditReqScreen> createState() => _EditReqScreenState();
}

class _EditReqScreenState extends State<EditReqScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor'),
        leading: BackButton(),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('EditRequest').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Shall I Update?'),
                          content:
                              Text('GstNo - ${data[index]['being edited']}'),
                          actions: [
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel')),
                            OutlinedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('EditRequest')
                                      .doc(
                                          "${data[index]['editor']}-${data[index]['being edited']}")
                                      .delete();
                                  Navigator.pop(context);
                                },
                                child: Text('No')),
                            OutlinedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('rating')
                                      .doc(data[index]['being edited'])
                                      .update({
                                    data[index]['type_of_edit'].toString():
                                        data[index]['new_entry'],
                                  });
                                  FirebaseFirestore.instance
                                      .collection('EditRequest')
                                      .doc("${data[index]['editor']}-${data[index]['being edited']}")
                                      .delete();
                                  Navigator.pop(context);
                                },
                                child: Text('Yes')),
                          ],
                        );
                      },
                    );
                  },
                  contentPadding: EdgeInsets.all(15),
                  title: Text(data[index]['being edited'].toString()),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 1.h),
                      Text('By - ${data[index]['editor']}'),
                      Text('Type - ${data[index]['type_of_edit']}'),
                      Row(
                        children: [
                          Text('Old - ${data[index]['old_entry']}'),
                          SizedBox(width: 5.w),
                          Text('New - ${data[index]['new_entry']}'),
                        ],
                      ),
                      // SizedBox(height: 2.h),
                    ],
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
