import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<Map<String, dynamic>> posts = [
    {
      'name': 'Maya R.',
      'time': '8 min ago',
      'title': 'Volunteer team checking supplies near station 4.',
      'likes': 24,
      'liked': false,
    },
    {
      'name': 'Lucas T.',
      'time': '24 min ago',
      'title': 'Medical aid list updated for the flood recovery group.',
      'likes': 18,
      'liked': true,
    },
    {
      'name': 'Aisha K.',
      'time': '1 hour ago',
      'title': 'Local residents organizing a food and water drive.',
      'likes': 32,
      'liked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Community Feed',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  final liked = post['liked'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B3340),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: const Color(0xFF7EC7F7),
                              child: Text(
                                post['name'][0],
                                style: const TextStyle(
                                  color: Color(0xFF102A3C),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    post['time'],
                                    style: const TextStyle(
                                      color: Color(0xFF9CB1C3),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          post['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  posts[index]['liked'] = !(posts[index]['liked'] as bool);
                                  if (posts[index]['liked']) {
                                    posts[index]['likes'] = (posts[index]['likes'] as int) + 1;
                                  } else {
                                    posts[index]['likes'] = (posts[index]['likes'] as int) - 1;
                                  }
                                });
                              },
                              icon: Icon(
                                liked ? Icons.favorite : Icons.favorite_border,
                                color: liked ? Colors.red : Colors.white70,
                              ),
                            ),
                            Text(
                              '${post['likes']} likes',
                              style: const TextStyle(color: Color(0xFFB1C7D8)),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Post shared')),
                                );
                              },
                              icon: const Icon(Icons.share_outlined, color: Colors.white70),
                              label: const Text('Share', style: TextStyle(color: Colors.white70)),
                            ),
                          ],
                        ),
                      ],
                    ),
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
