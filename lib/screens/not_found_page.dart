import 'package:flutter/material.dart';
import 'package:sample/routes/app_routes.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('404'),
            Text('page not found'),
            FilledButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
              child: Text('RETURN HOME'),
            ),
          ],
        ),
      ),
    );
  }
}
