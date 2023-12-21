import 'package:flutter/material.dart';
import 'package:nomo_ui_kit/components/loading/shimmer/shimmer.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/widgets/balance_display.dart';
import 'package:swapping_webon/widgets/price_display.dart';
import 'package:swapping_webon/widgets/token.dart';

class WalletWidget extends StatelessWidget {
  final Token token;
  final void Function()? onTap;
  //TokenEntity get token => tokenArgs.token;

  const WalletWidget({
    super.key,
    required this.token,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Shimmer(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashColor: context.theme.colors.primary,
            borderRadius: BorderRadius.circular(4),
            onTap: onTap,
            child: Container(
              color: Colors.transparent,
              padding: onTap == null
                  ? const EdgeInsets.all(4)
                  : const EdgeInsets.all(8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const pictureSize = 48.0;
                  const spacing = 16.0;
                  final maxWidth =
                      constraints.maxWidth - pictureSize - 2 * spacing;
                  final valueWidth = maxWidth * 0.4;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // TokenPicture(
                      //   token: token,
                      // ),
                      const SizedBox(
                        width: spacing,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NomoText(
                              token.name!,
                              style: context.typography.b2.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              fontWeight: FontWeight.w700,
                            ),
                            NomoText(
                              token.symbol,
                              style: context.typography.b2,
                              fontSize: 13,
                              opacity: 0.5,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: spacing,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: valueWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            PriceDisplay(
                              token,
                            ),
                            BalanceDisplay(
                              token,
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
