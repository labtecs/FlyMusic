import 'package:flutter/material.dart';

class ImpressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Impressum"),
      ),
      body: ListView(
        children: <Widget>[

          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
          ),
          Text("Eine App von:", style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
          Text("Kilian und Oliver", style: TextStyle(fontSize: 30), textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
