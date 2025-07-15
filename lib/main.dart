import 'package:flutter/material.dart';
import 'product.dart';
import 'product_list_page.dart';

void main() {
  runApp(PoseMarketApp());
}

class PoseMarketApp extends StatelessWidget {
  const PoseMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POSEMARKET',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: ProductListPage(),
    );
  }
}
