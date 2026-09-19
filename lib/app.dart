import 'package:flutter/material.dart';

import 'pages/ai_assistant_page.dart';
import 'pages/home_page.dart';
import 'pages/report_page.dart';
import 'pages/safe_route_page.dart';
import 'pages/trust_scan_page.dart';

class CivicHavenApp extends StatelessWidget {
  const CivicHavenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CivicHaven',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F1720),
        primaryColor: const Color(0xFF7EC7F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7EC7F7),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: const BottomNavShell(),
      routes: {
        '/report': (_) => const ReportPage(),
        '/route': (_) => const SafeRoutePage(),
        '/ai': (_) => const AIGuidePage(),
        '/scan': (_) => const TrustScanPage(),
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
    SafeRoutePage(),
    AIGuidePage(),
    ReportPage(),
    TrustScanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1720),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF121C26),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() => _selectedIndex = value);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: 'Route'),
          NavigationDestination(icon: Icon(Icons.smart_toy_outlined), selectedIcon: Icon(Icons.smart_toy), label: 'AI Guide'),
          NavigationDestination(icon: Icon(Icons.report_problem_outlined), selectedIcon: Icon(Icons.report_problem), label: 'Report'),
          NavigationDestination(icon: Icon(Icons.verified_user_outlined), selectedIcon: Icon(Icons.verified_user), label: 'Scan'),
        ],
      ),
    );
  }
}
