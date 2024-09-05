import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final String assetName;

  const LogoWidget({super.key, required this.assetName});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Image.asset(
        assetName,
      ),
    );
  }
}
