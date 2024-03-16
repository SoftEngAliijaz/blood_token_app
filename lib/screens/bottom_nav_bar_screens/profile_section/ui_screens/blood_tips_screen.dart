import 'package:blood_token_app/models/ui_models/tips_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

class BloodTipsScreen extends StatelessWidget {
  const BloodTipsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Tips'),
      ),
      body: ListView.builder(
        itemCount: tipsModel.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListTile(
                leading: Icon(Icons.text_fields_outlined, color: Colors.blue),
                title: Text(tipsModel[index].text),
                trailing: IconButton(
                  onPressed: () {
                    Share.share(tipsModel[index].text).then(
                        (value) => Fluttertoast.showToast(msg: 'Sharing...'));
                  },
                  icon: const Icon(Icons.share_outlined, color: Colors.blue),
                ),
              ));
        },
      ),
    );
  }
}
