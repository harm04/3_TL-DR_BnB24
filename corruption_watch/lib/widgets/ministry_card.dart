import 'package:flutter/material.dart';

Widget ministryCard(BuildContext context,ImageProvider<Object> image,String text,){
  return Card(
   
    elevation: 20,child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15)
      ),
      height: MediaQuery.of(context).size.height*0.26,
      width: MediaQuery.of(context).size.width*0.4,
      child: Column(
        children: [
          const SizedBox(height: 20,),
           Text(text,style: const TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
          const SizedBox(height: 10,),
          Container(
            
            child: Expanded(child: Padding(
              padding: const EdgeInsets.all( 10.0),
              child: Image(image: image,fit: BoxFit.cover,),
            )))
        ],
      ),
    ),
    
  );
}