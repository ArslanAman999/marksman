import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizeChartPage extends StatelessWidget {
  const SizeChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xFFDBD2E0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //LOGO
           Image.asset('assets/images/ourlogo.png',
              height: 45,
              color: Colors.black,),

            IconButton(
                onPressed: (){},
                iconSize: 30,
                icon: Icon(Icons.straighten),
              color: Colors.black,
            
            ),
          ],
        ),
      ),

      backgroundColor: Color(0xFFDBD2E0),
      body:SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              //SHOES-ICON
              Image.asset('assets/images/shoesicon.png',
              height: 250,),

              const SizedBox(height: 20),

              Text('-SIZE CHART-',
                  style: TextStyle(
                fontSize: 24.0,
                    fontWeight: FontWeight.bold,)),

                const SizedBox(height: 20),

              //SIZE-CHART
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Image.asset('assets/images/SizeChart.jpg'),
              ),

            ],
          ),
        ),
      )
    );
  }
}
