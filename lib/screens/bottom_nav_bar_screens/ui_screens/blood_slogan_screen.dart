import 'package:blood_token_app/models/ui_models/slogan_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

class BloodSloganScreen extends StatelessWidget {
  const BloodSloganScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BloodSloganScreen'),
      ),
      body: ListView.builder(
        itemCount: slogans.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: Icon(
                Icons.text_fields_outlined,
                color: Colors.blue,
              ),
              title: Text(slogans[index].text),
              trailing: IconButton(
                onPressed: () {
                  Share.share(slogans[index].text).then(
                      (value) => Fluttertoast.showToast(msg: 'Sharing...'));
                },
                icon: const Icon(
                  Icons.share_outlined,
                  color: Colors.blue,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
