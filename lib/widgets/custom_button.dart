import 'package:flutter/material.dart';

Widget customButton({height, width}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(4, 4),
          ),
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(-5, -8),
          ),
        ]),
  );
}
