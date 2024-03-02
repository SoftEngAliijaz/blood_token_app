import 'package:flutter/material.dart';

class AppUtils {
  ///CircularProgressIndicator
  static Center customProgressIndicator() => const Center(
      child: CircularProgressIndicator(
          color: Colors.red, backgroundColor: Colors.white));

  ///profile screen info cards
  ///where we show profile info
  ///like name,email etc
  static Card profileCard(
    IconData leadingIcon,
    String title,
    String subtitle,
  ) {
    return Card(
        child: ListTile(
      leading: Icon(leadingIcon),
      title: Text(title),
      subtitle: Text(subtitle),
    ));
  }
}
