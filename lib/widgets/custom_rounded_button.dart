import 'package:flutter/material.dart';

class CustomRoundedButton extends StatelessWidget {
  final Function() onPressed;
  final Widget child;

  const CustomRoundedButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints.tightFor(width: 56, height: 56),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: child,
    );
  }
}