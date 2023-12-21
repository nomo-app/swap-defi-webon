class Token {
  String? name;
  String symbol;
  int decimals;
  String? contractAddress;
  String? balance;
  String? network;
  String? receiveAddress;

  Token({
    required this.name,
    required this.symbol,
    required this.decimals,
    required this.contractAddress,
    required this.balance,
    required this.network,
    required this.receiveAddress,
  });
}
