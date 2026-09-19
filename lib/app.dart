import 'package:flutter/material.dart';

import 'pages/community_page.dart';
import 'pages/home_page.dart';
import 'pages/map_page.dart';
import 'pages/profile_page.dart';
import 'pages/report_page.dart';
import 'pages/emergency_detail_page.dart';

class CivicHavenApp extends StatelessWidget {
  const CivicHavenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CivicHaven',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1B2129),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7EC7F7),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: const BottomNavShell(),
      routes: {
        '/report': (_) => const ReportPage(),
        '/details': (_) => const EmergencyDetailsPage(),
      },
    );
  }
}

class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    MapPage(),
    CommunityPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2129),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF121821),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() => _selectedIndex = value);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Community',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
