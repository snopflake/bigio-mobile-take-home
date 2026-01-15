import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final int? characterId;

  const DetailPage({super.key, required this.characterId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Detail ID: $characterId'),
      ),
    );
  }
}
