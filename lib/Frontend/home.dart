import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constant/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Foody',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_active,
              color: Colors.amber,
              size: 30,
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(title: const Text("Profile"), onTap: () {}),
            ListTile(title: const Text("Favorites"), onTap: () {}),
            ListTile(title: const Text("Cart"), onTap: () {}),
            ListTile(title: const Text("Notifications"), onTap: () {}),
            ListTile(title: const Text("Settings"), onTap: () {}),
            ListTile(title: const Text("Share"), onTap: () {}),
            ListTile(title: const Text("Log Out"), onTap: () {}),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        color: lightGrey,
        child: const Column(
          children: [],
        ),
      ),
    );
  }
}
