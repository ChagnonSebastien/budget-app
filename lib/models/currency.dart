class Currency {
  const Currency({
    required this.decimals,
  });

  final int decimals;
}

Currency cad = const Currency(decimals: 2);

