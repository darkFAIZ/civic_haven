import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/data_service.dart';

class SafeRoutePage extends StatefulWidget {
  const SafeRoutePage({super.key});

  @override
  State<SafeRoutePage> createState() => _SafeRoutePageState();
}

class _SafeRoutePageState extends State<SafeRoutePage> {
  Position? position;
  bool busy = false;
  String message = 'Use your current location to plan a safer route.';

  Future<void> useMyLocation() async {
    setState(() => busy = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw StateError('Turn on Location Services first.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        throw StateError('Location permission was not granted.');
      }
      final current = await Geolocator.getCurrentPosition();
      final mapsUri = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=${current.latitude},${current.longitude}&destination=Main%20Station');
      await DataService.instance.addHistory(
        type: 'safe_route',
        title: 'Safe route planned',
        details: {'latitude': current.latitude, 'longitude': current.longitude, 'destination': 'Main Station'},
      );
      setState(() {
        position = current;
        message = 'Route saved. Opening directions from your current location.';
      });
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    } catch (error) {
      setState(() => message = error.toString().replaceFirst('Bad state: ', ''));
    } finally {
      setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeStops = [
      'Home',
      'Well-lit alley',
      'Main station',
      'Safety checkpoint',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F1720),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1720),
        foregroundColor: Colors.white,
        title: const Text('Safe route'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1F2B36),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recommended route',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    style: TextStyle(
                      color: Color(0xFF9FB7C7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF101B22),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: List.generate(routeStops.length, (index) {
                        final isLast = index == routeStops.length - 1;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7EC7F7),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                                if (!isLast)
                                  Container(
                                    width: 2,
                                    height: 40,
                                    color: const Color(0xFF334759),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding: EdgeInsets.only(top: index == 0 ? 0 : 8, bottom: isLast ? 0 : 8),
                              child: Text(
                                routeStops[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Quick actions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ActionCard(
                    title: 'Call police',
                    icon: Icons.call,
                    color: const Color(0xFF7EC7F7),
                      onTap: () async {
                        await launchUrl(Uri(scheme: 'tel', path: '112'));
                      },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionCard(
                    title: 'Share location',
                    icon: Icons.location_on,
                    color: const Color(0xFF6EE7B7),
                    onTap: busy ? null : useMyLocation,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2B36),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      ),
    );
  }
}
