import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlaceAppbar1 extends StatelessWidget {
  const PlaceAppbar1({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 50,
      automaticallyImplyLeading: false,
      // floating: true,
      // pinned: true,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Color.fromARGB(255, 35, 73, 145),
          child: SafeArea(
            child: Padding(
              padding: const .symmetric(horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: .center,
                mainAxisAlignment: .spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Column(
                    children: [
                      Text('Hello', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('World', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}