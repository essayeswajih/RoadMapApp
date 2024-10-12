import 'package:flutter/material.dart';
import 'aboutPage.dart';
import 'helpPage.dart';
import 'homePage.dart';

class MyDrower extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/images/IMG_20240218_203439.jpg'),
            ),
            accountEmail: Text('wajihsayes@gmail.com'),
            accountName: Text(
              'Essayed Mohamed Wajih',
              style: TextStyle(fontSize: 24.0),
            ),
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.house),
            title: const Text(
              'Home',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: 'AI Job Roadmap')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text(
              'About',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text(
              'Help',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HelpPage()));
            },
          ),
        ],

      ),
    );
  }

}