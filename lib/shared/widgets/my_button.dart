import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final VoidCallback? onPressed;
  final IconData? icon;

  const MyButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    this.onPressed, this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, color: Colors.white) : const SizedBox.shrink(),
      label: Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
