import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/top.jpeg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Expanded(
                    child: Image.asset(
                  'assets/images/bottom.jpeg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                )),
              ],
            ),
            Positioned(
              left: 10,
              right: 10,
              top: 10,
              bottom: 10,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                width: 400,
              ),
            )
          ],
        ));
  }
}
