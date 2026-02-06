import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.rocket)) ,
        actions: [


          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {  }, icon: Icon(Icons.account_circle),
           ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {  }, icon: Icon(Icons.logout),
            ),
          )

        ],
      ),
      extendBodyBehindAppBar: true,
      body: Center(

        child: SearchBar(
          hintText: "Search",
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16)
          )),
        ),
      ),
    );
  }
}
