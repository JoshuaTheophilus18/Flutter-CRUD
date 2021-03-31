import 'package:flutter/material.dart';
import './pages/product.dart';
import 'package:provider/provider.dart';
import 'package:flutter_vs_code/providers/product_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        )
      ],
      child: MaterialApp(
        home: Product(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}