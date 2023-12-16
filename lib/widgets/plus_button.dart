import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  final void Function()? onTap;
  const PlusButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      spreadRadius: 10,
                      blurRadius: 3)
                ]),
            height: 75,
            width: 75,
            child: const Center(
                child: Text(
              "+",
              style: TextStyle(fontSize: 35),
            ))),
      ),
    );
  }
}
