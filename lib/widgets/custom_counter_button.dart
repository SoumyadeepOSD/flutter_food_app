import 'package:flutter/material.dart';

Widget customCounterButton(
    {String? type, Function? onCounter, String? pid, String? cid}) {
  return GestureDetector(
    onTap: () {
      onCounter!(pid, cid, type);
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: type == "up" ? Colors.green : Colors.red,
          width: 1.0,
        ),
        color: type == "up" ? Colors.green.shade50 : Colors.red.shade50,
      ),
      child: Center(
        child: Icon(
          type == "up"
              ? Icons.arrow_upward_rounded
              : Icons.arrow_downward_rounded,
          color: type == "up" ? Colors.green : Colors.red,
        ),
      ),
    ),
  );
}
