import 'package:blood_token_app/constants/constants.dart';
import 'package:blood_token_app/models/ui_models/quote_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

class BloodQuotesScreen extends StatelessWidget {
  const BloodQuotesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotes'),
      ),
      body: ListView.builder(
        itemCount: quotesModel.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ListTile(
              leading: const Icon(
                Icons.text_fields_outlined,
                color: AppUtils.blueColor,
              ),
              title: Text(quotesModel[index].text),
              trailing: IconButton(
                onPressed: () {
                  Share.share(quotesModel[index].text).then(
                      (value) => Fluttertoast.showToast(msg: 'Sharing...'));
                },
                icon: const Icon(
                  Icons.share_outlined,
                  color: AppUtils.blueColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
