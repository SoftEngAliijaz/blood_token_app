import 'package:flutter/material.dart';

class MyBloodRequestsScreen extends StatelessWidget {
  const MyBloodRequestsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Blood Requests'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ExpansionTile(
              children: [
                Text('data'),
                Text('data'),
                Text('data'),
              ],
              leading: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined),
              ),
              title: Text('My Blood Requests'),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
