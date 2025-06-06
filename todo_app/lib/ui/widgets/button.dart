import 'package:flutter/material.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:flutter/cupertino.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const MyButton({Key? key, required this.label, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: primaryClr,
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class MyButton1 extends StatelessWidget {
  final String label;
  final Function()? onTap;
  const MyButton1({Key? key, required this.label, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: pinkClr,
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
