import 'package:flutter/material.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/model/tx_history_entity.dart';
import 'package:swapping_webon/widgets/token_picture.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';

class CurrencyItem extends StatelessWidget {
  const CurrencyItem({
    super.key,
    required this.currency,
    required this.status,
  });
  final Token currency;
  final SwapTxConfirmationState status;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                status == SwapTxConfirmationState.expired
                    ? context.theme.typography.b1.color!
                    : Colors.transparent,
                BlendMode.saturation,
              ),
              child: TokenPicture(
                token: currency,
                size: 48,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        NomoText(
          color: Colors.grey[400],
          currency.symbol,
          style: context.typography.b3,
        ),
      ],
    );
  }
}
