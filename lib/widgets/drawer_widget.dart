import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(child: _drawerContent()),
          _drawerMenuItems(
            title: 'Profile',
            icon: Icons.person,
            function: () {},
          ),
          _drawerMenuItems(
            title: 'settings',
            icon: Icons.settings,
            function: () {},
          ),
        ],
      ),
    );
  }

  Widget _drawerContent() {
    return Column(children: [Image.asset(''), Text("News App")]);
  }

  Widget _drawerMenuItems({
    required String title,
    required IconData icon,
    required Function function,
  }) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: () {
        function();
      },
    );
  }
}
