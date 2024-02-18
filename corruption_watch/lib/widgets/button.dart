import 'package:flutter/material.dart';

Widget button(
  String text,
  double height,
  double width,
) {
  return Card(
    color: Colors.white,
    elevation: 20,
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          height: height,
          width: width,
          child: Center(
              child: Text(
            text,
            style: const TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w600),
          )),
        ),
      ],
    ),
  );
}
