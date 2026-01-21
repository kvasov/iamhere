import 'package:flutter/material.dart';

class ExtraScreen extends StatelessWidget {
  const ExtraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [Center(child: Text("data"))]),
    );
  }
}
