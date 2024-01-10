class Token {
  String? name;
  String symbol;
  int decimals;
  String? contractAddress;
  String? balance;
  String? network;
  String? receiveAddress;
  double? selectedValue;

  Token({
    required this.name,
    required this.symbol,
    required this.decimals,
    required this.contractAddress,
    required this.balance,
    required this.network,
    required this.receiveAddress,
    this.selectedValue,
  });

  Token copyWith({
    String? name,
    String? symbol,
    int? decimals,
    String? contractAddress,
    String? balance,
    String? network,
    String? receiveAddress,
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
      selectedValue: selectedValue ?? this.selectedValue,
    );
  }
}
