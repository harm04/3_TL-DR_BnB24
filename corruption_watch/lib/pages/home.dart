import 'package:corruption_watch/widgets/button.dart';
import 'package:corruption_watch/widgets/ministry_card.dart';
import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Corruption watch',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Select Ministry',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ministryCard(
                    context,
                    const AssetImage('assets/images/law.jpeg'),
                    'Law\'s and Judes'),
                const SizedBox(
                  width: 20,
                ),
                ministryCard(
                    context,
                    const AssetImage('assets/images/panchayatiRaj.jpeg'),
                    'Panchayati raj')
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ministryCard(context,
                    const AssetImage('assets/images/defence.jpeg'), 'Defence'),
                const SizedBox(
                  width: 20,
                ),
                ministryCard(context,
                    const AssetImage('assets/images/revenue.jpeg'), 'Revenue')
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(onTap: () {}, child: button('Others', 50, 350,Colors.white)),
          ],
        ),
      ),
    );
  }
}
