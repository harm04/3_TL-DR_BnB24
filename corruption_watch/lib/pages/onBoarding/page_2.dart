import 'package:corruption_watch/pages/home.dart';
import 'package:corruption_watch/widgets/button.dart';
import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                  'assets/images/stopCorruption.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // Text(
            //   'Complain and stay anonymous!',
            //   style: TextStyle(color: Colors.black, fontSize: 35,fontWeight: FontWeight.bold),
            // ),
            
            const Text(
              'Complain and stay ',
              style: TextStyle(color: Colors.black, fontSize: 35,fontWeight: FontWeight.bold),
            ),
            const Text('anonymous!',style: TextStyle(color: Colors.black, fontSize: 35,fontWeight: FontWeight.bold),),
            const Text('You are safe here !'),
            SizedBox(height: 70,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(  )));
                },
                child: button('Get started', 50, double.infinity,Colors.blue)),
            )
                    ],
                  ),
          )),
    );
  }
}
