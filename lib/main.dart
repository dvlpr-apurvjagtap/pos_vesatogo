// main.dart
import 'package:flutter/material.dart';
import 'package:pos_vesatogo/core/database/database_service.dart';
import 'package:pos_vesatogo/core/theme/theme_controller.dart';
import 'package:pos_vesatogo/features/pos/data/data_sources/product_local_source.dart';
import 'package:pos_vesatogo/features/pos/presentation/screens/pos_screen.dart';
import 'package:pos_vesatogo/features/pos/providers/cart_provider.dart';
import 'package:pos_vesatogo/features/pos/providers/order_provider.dart';
import 'package:pos_vesatogo/features/pos/providers/product_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseService.init();

  final productSource = ProductLocalSource();
  await productSource.seedProductsIfEmpty();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeController()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'POS Vesatogo',
            theme: themeController.getThemeMode,
            home: const PosScreen(),
          );
        },
      ),
    );
  }
}
