import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/transaction.dart';
import 'package:getwidget/components/card/gf_card.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.transaction,
    this.textSize = 11,
  });

  final Transaction transaction;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    List<Widget> cardContent = [
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          transaction.category?.iconData ?? Icons.attach_money,
          color: transaction.category?.iconColor ?? Colors.green,
          size: textSize * 2.8,
        ),
      ),
      Expanded(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transaction.note ?? (transaction.category == null ? "Initial amount" : transaction.category!.name),
            style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w700),
          ),
          Text(
            transaction.currency.formatFull(transaction.amount),
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
              transaction.from == null ? "" : 'From: ',
              style: TextStyle(fontSize: textSize),
            ),
            Text(
              'To: ',
              style: TextStyle(fontSize: textSize),
            ),
          ],
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.from == null ? "" : transaction.from!.name,
              style: TextStyle(fontSize: textSize),
            ),
            Text(
              transaction.to.name,
              style: TextStyle(fontSize: textSize),
            ),
          ],
        ),
      ),
    ];

    return GFCard(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(3))),
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.all(5),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cardContent,
      ),
    );
  }
}
