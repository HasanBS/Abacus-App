import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatelessWidget {
  final String path;
  final bool? repeat;
  const LottieWidget({
    Key? key,
    required this.path,
    this.repeat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(path, repeat: repeat);
  }
}
