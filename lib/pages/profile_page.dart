import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/data_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFF0F1720),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Profile', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    icon: const Icon(Icons.logout, color: Color(0xFFFF9B9B)),
                    tooltip: 'Sign out',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: const Color(0xFF1F2B36), borderRadius: BorderRadius.circular(22)),
                child: Row(
                  children: [
                    const CircleAvatar(radius: 30, backgroundColor: Color(0xFF7EC7F7), child: Icon(Icons.person, color: Color(0xFF102A3C), size: 30)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('CivicHaven member', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(user?.phoneNumber ?? 'Verified phone account', style: const TextStyle(color: Color(0xFFB1C7D8))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('My history', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Expanded(
                child: StreamBuilder(
                  stream: DataService.instance.watchHistory(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('History is unavailable until Firestore is configured.', style: TextStyle(color: Color(0xFFFF9B9B))));
                    }
                    final items = snapshot.data?.docs ?? [];
                    if (items.isEmpty) {
                      return const Center(child: Text('Your reports, scans, and routes will appear here.', style: TextStyle(color: Color(0xFF9FB7C7))));
                    }
                    return ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final data = items[index].data() as Map<String, dynamic>;
                        final type = data['type'] as String? ?? 'activity';
                        return Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(color: const Color(0xFF1F2B36), borderRadius: BorderRadius.circular(17)),
                          child: Row(
                            children: [
                              Icon(_iconFor(type), color: const Color(0xFF7EC7F7)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['title'] as String? ?? 'Activity', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(type.replaceAll('_', ' '), style: const TextStyle(color: Color(0xFF9FB7C7), fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'document_scan':
        return Icons.verified_user_outlined;
      case 'safe_route':
        return Icons.route_outlined;
      case 'report':
        return Icons.report_problem_outlined;
      default:
        return Icons.history;
    }
  }
}
