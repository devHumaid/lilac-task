import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key}) : preferredSize = Size.fromHeight(70.0), super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 70.0, left: 16.0, right: 16.0),
          child: Row(
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(56, 0, 0, 0).withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child:Icon(Icons.arrow_back, color: Colors.black, size: 20),
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
