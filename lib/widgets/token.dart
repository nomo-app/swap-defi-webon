class Token {
  final String? name;
  final String symbol;
  final int decimals;
  final String? contractAddress;
  final String? balance;
  final String? network;
  final String? receiveAddress;

  const Token({
    required this.name,
    required this.symbol,
    required this.decimals,
    required this.contractAddress,
    required this.balance,
    required this.network,
    required this.receiveAddress,
  });

  Token copyWith({
    String? name,
    String? symbol,
    int? decimals,
    String? contractAddress,
    String? balance,
    String? network,
    String? receiveAddress,
    String? assetIcon,
    double? selectedValue,
  }) {
    return Token(
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      decimals: decimals ?? this.decimals,
      contractAddress: contractAddress ?? this.contractAddress,
      balance: balance ?? this.balance,
      network: network ?? this.network,
      receiveAddress: receiveAddress ?? this.receiveAddress,
    );
  }

  static String getAssetName(Token token) {
    final String symbol;

    if (token.symbol == "ZENIQ Coin" ||
        token.symbol == "ZENIQ Token" ||
        token.symbol == "ZENIQ @ETH" ||
        token.symbol == "ZENIQ @BSC") {
      symbol = "ZENIQ Coin";
    } else if (token.symbol == "USDC") {
      symbol = "usd-coin";
    } else if (token.symbol == "AVINOC ERC20" ||
        token.symbol == "AVINOC ZEN20") {
      symbol = 'avinoc';
    } else if (token.symbol == "WBTC") {
      symbol = "BTC";
    } else {
      symbol = token.symbol;
    }

    return symbol.toLowerCase();
  }

  @override
  String toString() {
    return 'Token(name: $name)';
  }
}
