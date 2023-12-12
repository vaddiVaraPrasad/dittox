import "package:flutter/material.dart";

import "../../utils/color_pallets.dart";

import "./loading_indicator.dart";
import "./circular_press_button.dart";

class SignInBar extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const SignInBar({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: ColorPallets.deepBlue,
              fontSize: 24,
            ),
          ),
          Expanded(
            child: Center(
              child: LoadingProgressIndicator(
                isLoading: isLoading,
              ),
            ),
          ),
          RoundContinueButton(
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}

class SignUpBar extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const SignUpBar({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: ColorPallets.white,
              fontSize: 24,
            ),
          ),
          Expanded(
            child: Center(
              child: LoadingProgressIndicator(
                isLoading: isLoading,
              ),
            ),
          ),
          RoundContinueButton(
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}
