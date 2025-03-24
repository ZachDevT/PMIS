import 'package:flutter/material.dart';

class TpriceText extends StatelessWidget {
  const TpriceText({
    super.key,
    this.currencySign = '\$',
    required this.price,
    this.maxlines = 1,
    this.lineTrough = false,
    this.isLarge = false,
  });

  final String currencySign, price;
  final bool isLarge;
  final int maxlines;
  final bool lineTrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      currencySign + price,
      style: isLarge
          ? Theme.of(context)
              .textTheme
              .headlineMedium!
              .apply(decoration: lineTrough ? TextDecoration.lineThrough : null)
          : Theme.of(context).textTheme.titleLarge!.apply(
              decoration: lineTrough ? TextDecoration.lineThrough : null),
      maxLines: maxlines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
