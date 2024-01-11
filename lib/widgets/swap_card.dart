import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nomo_ui_kit/components/buttons/base/nomo_button.dart';
import 'package:nomo_ui_kit/components/buttons/primary/nomo_primary_button.dart';
import 'package:nomo_ui_kit/components/buttons/text/nomo_text_button.dart';
import 'package:nomo_ui_kit/components/card/nomo_card.dart';
import 'package:nomo_ui_kit/components/text/nomo_text.dart';
import 'package:nomo_ui_kit/theme/nomo_theme.dart';
import 'package:swapping_webon/provider/asset_provider.dart';
import 'package:swapping_webon/widgets/amount.dart';
import 'package:swapping_webon/widgets/input_actions.dart';
import 'package:swapping_webon/widgets/swap_asset_input.dart';
import 'package:swapping_webon/widgets/token.dart';

final hasErrorProviderTo = StateProvider<bool>((ref) => false);
final hasErrorProviderFrom = StateProvider<bool>((ref) => false);

class SwapCard extends ConsumerStatefulWidget {
  const SwapCard({super.key});

  @override
  ConsumerState<SwapCard> createState() => _SwapCardState();
}

class _SwapCardState extends ConsumerState<SwapCard> {
  final fromTextNotifer = ValueNotifier('');
  final toTextNotifer = ValueNotifier('');

  @override
  void initState() {
    fromTextNotifer.addListener(fromChanged);
    toTextNotifer.addListener(toChanged);
    super.initState();
  }

  @override
  void dispose() {
    fromTextNotifer
      ..removeListener(fromChanged)
      ..dispose();
    toTextNotifer
      ..removeListener(toChanged)
      ..dispose();
    super.dispose();
  }

  //Todo: fix enter value not updating with floating point

  void fromChanged() {
    final changedValue = double.tryParse(fromTextNotifer.value);

    if (changedValue != null) {
      final fromToken = ref.read(fromProvider);
      if (fromToken != null) {
        ref.read(hasErrorProviderFrom.notifier).state =
            checkForError(fromToken, changedValue);

        if (!ref.read(hasErrorProviderFrom)) {
          ref.read(fromProvider.notifier).state =
              fromToken.copyWith(selectedValue: changedValue);
        }
      }
      print("from changed $changedValue");
    }
  }

  bool checkForError(Token token, double value) {
    if (token.balance != null) {
      Amount amount = Amount.fromString(
          value: token.balance ?? "0", decimals: token.decimals);

      if (value > amount.displayValue) {
        return true;
      }
    }
    return false;
  }

  void toChanged() {
    final changedValue = double.tryParse(toTextNotifer.value);

    if (changedValue != null) {
      final toToken = ref.read(toProvider);
      if (toToken != null) {
        ref.read(hasErrorProviderFrom.notifier).state =
            checkForError(toToken, changedValue);

        if (!ref.read(hasErrorProviderFrom)) {
          ref.read(toProvider.notifier).state =
              toToken.copyWith(selectedValue: changedValue);
        }
      }
      print("from changed $changedValue");
    }
  }

  @override
  Widget build(BuildContext context) {
    final fromToken = ref.watch(fromProvider);
    final toToken = ref.watch(toProvider);

    final hasErrorTo = ref.watch(hasErrorProviderTo);
    final hasErrorFrom = ref.watch(hasErrorProviderFrom);

    bool showBottomInfoFrom = false;
    bool showBottomInfoTo = false;

    if (fromToken != null) {
      showBottomInfoFrom = true;

      if (fromToken.selectedValue != null) {
        fromTextNotifer.value = fromToken.selectedValue.toString();
      }
    }

    if (toToken != null) {
      showBottomInfoTo = true;
      if (toToken.selectedValue != null) {
        toTextNotifer.value = toToken.selectedValue.toString();
      }
    }

    return NomoCard(
      borderRadius: BorderRadius.circular(8),
      elevation: 1,
      backgroundColor: context.theme.colors.surface,
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NomoText(
                    "From",
                    style: context.theme.typography.b3,
                  ),
                  NomoTextButton(
                    text: "Clear All",
                    padding: const EdgeInsets.all(8),
                    textStyle: context.theme.typography.b3.copyWith(
                      color: context.theme.colors.error,
                    ),
                    onPressed: () {
                      ref.read(fromProvider.notifier).state = null;
                      ref.read(toProvider.notifier).state = null;
                      toTextNotifer.value = "";
                      fromTextNotifer.value = "";
                    },
                  )
                ],
              ),
              const SizedBox(height: 24),
              SwapAssetInput(
                showBottomInfo: showBottomInfoFrom,
                inputActions: InputActions(token: fromToken, isFrom: true),
                isFrom: true,
                textNotifier: fromTextNotifer,
                showError: hasErrorFrom,
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.center,
                child: NomoButton(
                  backgroundColor: context.theme.colors.primary,
                  elevation: 2,
                  height: 40,
                  width: 40,
                  shape: BoxShape.circle,
                  child: Icon(
                    Icons.swap_vert,
                    size: 30,
                    color: context.theme.colors.onPrimary,
                  ),
                  onPressed: () {
                    ref.read(fromProvider.notifier).state = toToken;
                    ref.read(toProvider.notifier).state = fromToken;
                    final fromValueNotifier = fromTextNotifer.value;
                    final toValueNotifier = toTextNotifer.value;

                    toTextNotifer.value = fromValueNotifier;
                    fromTextNotifer.value = toValueNotifier;
                  },
                ),
              ),
              NomoText(
                "To",
                style: context.theme.typography.b3,
              ),
              const SizedBox(height: 24),
              SwapAssetInput(
                showBottomInfo: showBottomInfoTo,
                inputActions: InputActions(token: toToken, isFrom: false),
                isFrom: false,
                textNotifier: toTextNotifer,
                showError: hasErrorTo,
              ),
              const SizedBox(height: 64),
              PrimaryNomoButton(
                text: "Swap",
                textStyle: context.theme.typography.h2.copyWith(
                  color: context.theme.colors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
                onPressed: () {
                  print(ref.read(fromProvider.notifier).state?.selectedValue ??
                      "null");
                  print(ref.read(toProvider.notifier).state?.selectedValue ??
                      "null");
                },
                height: 48,
                width: double.infinity,
                elevation: 2,
                enabled: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
