import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:csv/csv.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:surat_weavers_new/library.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

String user = '';

class _ExportScreenState extends State<ExportScreen> {
  void exportCsv() async {

    final collection =
    await FirebaseFirestore.instance.collection('MainPartyDataCenter');
    final myData = await rootBundle.loadString('assets/PartyData.csv');
    List csvTable = CsvToListConverter().convert(myData);
    List data = [];
    data = csvTable;

    for(int i = 0 ; i < 403  ; i++) {
      print(data[i]);
      if (data[i][3] != '' && data[i][2] != '') {
        await FirebaseFirestore.instance
            .collection('rating')
            .doc(data[i][3].toString().toUpperCase())
            .set({
          'party_address': data[i][2].toString(),
          'party_company_name': data[i][1].toString(),
          'party_gst_no':
          data[i][3].toString().toUpperCase(),
          'party_mobile': data[i][4].toString(),
          'avg rating': 0.0,
          'who rated': {},
          'comments': {},
        });
      }
    }

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(onPressed: exportCsv,child: Text('export'),),
      ),
    );
  }
}
