import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/news_provider.dart';
import 'package:sample/providers/theme_provider.dart';
import 'package:sample/routes/app_routes.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider(), lazy: false),
        ChangeNotifierProvider(create: (_) => ThemeProvider(), lazy: false),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          onGenerateRoute: AppRoutes.onGenerateRoute,
          onUnknownRoute: AppRoutes.unknownRoute,
        );
      },
    );
  }
}
