import 'package:flutter/material.dart';
import 'package:flutter_hello_world/models/account.dart';


class AccountCard extends StatelessWidget  {
  const AccountCard({
    super.key,
    required this.account,
    this.textSize = 11,
  });
  
  final Account account;
  final double textSize;

  @override
  Widget build(BuildContext context) {


    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(account.name),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
