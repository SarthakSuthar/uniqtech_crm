import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget appToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );

  return const SizedBox.shrink(); // Return an empty widget
}
