class SwapAsset {
  final String symbol;
  final List<String> networks;

  const SwapAsset(this.symbol, this.networks);

  SwapAsset.fromJson(Map<String, dynamic> json)
      : symbol = json['coin'],
        networks = (json['networks'] as List<dynamic>)
            .map((e) => e as String)
            .toList();

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'networks': networks,
      };

  List<Object?> get props => [symbol, networks];
}
