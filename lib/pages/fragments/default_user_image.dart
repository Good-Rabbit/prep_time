import 'package:flutter/material.dart';

class DefaultUserImage extends StatelessWidget {
  const DefaultUserImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: Image.asset(
        'assets/images/user.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
