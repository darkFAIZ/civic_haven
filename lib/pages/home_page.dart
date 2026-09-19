import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class _QuickAction {
  const _QuickAction({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final quickActions = [
      _QuickAction(title: 'Safe Route', icon: Icons.route_outlined, color: const Color(0xFF7EC7F7), onTap: () {
        Navigator.of(context).pushNamed('/route');
      }),
      _QuickAction(title: 'AI Guide', icon: Icons.smart_toy_outlined, color: const Color(0xFF6EE7B7), onTap: () {
        Navigator.of(context).pushNamed('/ai');
      }),
      _QuickAction(title: 'Report', icon: Icons.warning_amber_rounded, color: const Color(0xFFFBBF24), onTap: () {
        Navigator.of(context).pushNamed('/report');
      }),
      _QuickAction(title: 'Scan Doc', icon: Icons.verified_user_outlined, color: const Color(0xFFA78BFA), onTap: () {
        Navigator.of(context).pushNamed('/scan');
      }),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CivicHaven',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F2B36),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.notifications_none, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7EC7F7), Color(0xFF4DA3C8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Understand → Verify → Protect → Act → Adapt',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF0F1720),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Emergency',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F1720),
                    ),
                  ),
                  const Text(
                    'Need Help?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Call emergency support or ask for a safer route home.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFDBF0FF),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final uri = Uri(scheme: 'tel', path: '112');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Phone dialer unavailable')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F2D41),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.call),
                          label: const Text('Call police'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick actions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              itemCount: quickActions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) {
                final action = quickActions[index];
                return Material(
                  color: const Color(0xFF1F2B36),
                  borderRadius: BorderRadius.circular(22),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: action.onTap,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: action.color.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(action.icon, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            action.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 28),
            const Text(
              'Latest alerts',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            const _AlertCard(
              title: 'Water outage near Riverside',
              badge: 'Infrastructure',
              time: '12 min ago',
            ),
            const SizedBox(height: 12),
            const _AlertCard(
              title: 'Volunteer aid hub opened',
              badge: 'Support',
              time: '31 min ago',
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.title,
    required this.badge,
    required this.time,
  });

  final String title;
  final String badge;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2B36),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF7EC7F7).withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.info_outline, color: Color(0xFF7EC7F7)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF9FB7C7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFC9F0FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: Color(0xFF153B52),
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
