import 'package:flutter/material.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';

class ErrorMessage extends StatelessWidget {
  final String? errorMessage;

  const ErrorMessage({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          color: context.theme.colors.foreground1,
        ),
        const SizedBox(width: 8),
        NomoText(
          errorMessage ?? "",
          color: context.theme.colors.foreground1,
          style: context.typography.b2,
        ),
      ],
    );
  }
}
