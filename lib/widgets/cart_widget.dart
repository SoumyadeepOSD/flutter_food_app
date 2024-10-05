import 'package:flutter/material.dart';
import 'package:foodapp/widgets/custom_counter_button.dart';

Widget cartItemWidget({item, cid, context, onDelete, onCounter}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
    width: MediaQuery.of(context).size.width,
    height: 150,
    margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: const Border(left: BorderSide(color: Colors.white)),
        color: Colors.lightBlue.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(4.0, 4.0),
            blurRadius: 10,
            spreadRadius: 1.0,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-14.0, -4.0),
            blurRadius: 10,
            spreadRadius: 1.0,
          )
        ]),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            fit: BoxFit.fill,
            item['image'].toString(),
            height: 80,
            width: 80,
          ),
        ),
        const SizedBox(
          width: 30.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item['qty'].toString()),
            Text(item['qty'].toString()),
            Text(item['qty'].toString()),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customCounterButton(
                  type: "up",
                  onCounter: onCounter,
                  pid: item['product'].toString(),
                  cid: cid,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(item['qty'].toString()),
                const SizedBox(
                  width: 10.0,
                ),
                customCounterButton(
                  type: "down",
                  onCounter: onCounter,
                  pid: item['product'].toString(),
                  cid: cid,
                ),
              ],
            )
          ],
        ),
        const SizedBox(
          width: 40.0,
        ),
        IconButton(
          onPressed: () {
            onDelete(item['product'].toString());
          },
          icon: const Icon(
            size: 40,
            Icons.restore_from_trash,
            color: Colors.red,
          ),
        )
      ],
    ),
  );
}
