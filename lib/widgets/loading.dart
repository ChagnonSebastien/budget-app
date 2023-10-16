import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(child: Container()),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [CircularProgressIndicator(strokeWidth: 5)]),
        Expanded(child: Container()),
      ]);
}
