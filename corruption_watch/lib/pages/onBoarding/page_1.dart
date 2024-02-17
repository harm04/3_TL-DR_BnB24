import 'package:corruption_watch/pages/onBoarding/page_2.dart';
import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Card(
                  elevation: 20,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    width: MediaQuery.of(context).size.width * 0.56,
                    child: Image.asset(
                      'assets/images/antiCorruption.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'One solution for',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  'corrupt system!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                const Text('You are safe here !'),
                const SizedBox(
                  height: 70,
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Page2()));
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.arrow_forward),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
