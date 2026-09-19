import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = [
      ('My reports', Icons.folder_outlined),
      ('Saved alerts', Icons.bookmark_outline),
      ('Notification settings', Icons.notifications_none),
      ('Privacy & safety', Icons.privacy_tip_outlined),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF2B3340),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF7EC7F7),
                    child: Icon(Icons.person, color: Color(0xFF102A3C), size: 30),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aisha Morgan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Community volunteer',
                          style: TextStyle(
                            color: Color(0xFFB1C7D8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit profile pressed')),
                      );
                    },
                    icon: const Icon(Icons.edit_note, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                _StatCard(label: 'Reports', value: '14'),
                SizedBox(width: 12),
                _StatCard(label: 'Helped', value: '58'),
                SizedBox(width: 12),
                _StatCard(label: 'Streak', value: '6d'),
              ],
            ),
            const SizedBox(height: 28),
            Expanded(
              child: ListView.builder(
                itemCount: settings.length,
                itemBuilder: (context, index) {
                  final item = settings[index];
                  return ListTile(
                    leading: Icon(item.$2, color: const Color(0xFF7EC7F7)),
                    title: Text(
                      item.$1,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Colors.white70),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${item.$1} opened')),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2B3340),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFB1C7D8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
