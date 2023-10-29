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
      Expanded(
        child: transaction.from == null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.from!.name,
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

    if (transaction.category != null) {
      cardContent.insert(
          0,
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              transaction.category!.iconData,
              color: transaction.category!.iconColor,
              size: textSize * 2.8,
            ),
          ));
    }

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
