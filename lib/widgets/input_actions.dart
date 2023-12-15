import 'package:flutter/material.dart';
import 'package:nomo_ui_kit/components/buttons/base/nomo_button.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';

class InputActions extends StatelessWidget {
  const InputActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: NomoText(
            "Balance: 233.23",
            style: context.theme.typography.b1,
            opacity: 0.5,
            maxLines: 2,
            minFontSize: 8,
          ),
        ),
        const Row(
          children: [
            InputActionButton(
              text: "25%",
            ),
            SizedBox(width: 8),
            InputActionButton(
              text: "50%",
            ),
            SizedBox(width: 8),
            InputActionButton(
              text: "75%",
            ),
            SizedBox(width: 8),
            InputActionButton(
              text: "max",
            ),
          ],
        )
      ],
    );
  }
}

class InputActionButton extends StatelessWidget {
  final String text;

  const InputActionButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return NomoButton(
      width: 40,
      borderRadius: BorderRadius.circular(4),
      backgroundColor: context.theme.colors.background2,
      border: Border.all(
        color: context.theme.colors.primary,
        width: 1,
      ),
      child: NomoText(
        minFontSize: 8,
        text,
        style: context.theme.typography.b1,
        color: context.theme.colors.primary,
      ),
      onPressed: () => print(text),
    );
  }
}
