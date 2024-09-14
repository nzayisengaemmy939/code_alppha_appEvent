import 'package:code_alpha_campus_event/colors.dart';
import 'package:flutter/material.dart';

class EventButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const EventButton({
    super.key,
    required this.text,
    this.isSelected = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
        foregroundColor: AppColors.font2,
        backgroundColor: isSelected ? AppColors.pressedButton : AppColors.button, // Change color based on selection
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
