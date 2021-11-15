import 'package:flutter/material.dart';

class ErrorCard extends StatelessWidget {
  final Object error;

  const ErrorCard({Key? key, required this.error}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('$error'),
    );
  }
}
