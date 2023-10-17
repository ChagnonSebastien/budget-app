
import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/transaction.dart';


class TransactionCard extends StatelessWidget  {
  const TransactionCard({
    super.key,
    required this.transaction,
    this.textSize = 11,
  });
  
  final Transaction transaction;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                transaction.category.iconData,
                color: transaction.category.iconColor,
                size: textSize * 2.8,
              ),
            ),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.note ?? transaction.category.name,
                  style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w700),
                ),
                Text(
                  transaction.currency.formatValue(transaction.amount),
                  style: TextStyle(fontSize: textSize),
                ),
              ],
            )),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'From: ',
                    style: TextStyle(fontSize: textSize),
                  ),
                  Text(
                    'To: ',
                    style: TextStyle(fontSize: textSize),
                  ),
                ],
              ),
            ),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.from.name,
                  style: TextStyle(fontSize: textSize),
                ),
                Text(
                  transaction.to.name,
                  style: TextStyle(fontSize: textSize),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
