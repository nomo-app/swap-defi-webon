import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swapping_webon/widgets/select_asset.dart';

final visibleAssetsProvider =
    FutureProvider((ref) async => await getAssetsFromNomo());
