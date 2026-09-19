import 'package:flutter/material.dart';

class AIGuidePage extends StatelessWidget {
  const AIGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatMessages = [
      ('AI', 'Here are the local safety rules around rentals and reporting in this district.'),
      ('You', 'What should I do if a broker asks for advance payment?'),
      ('AI', 'Do not pay upfront. Ask for a signed agreement, owner identity, and report the broker if the request is suspicious.'),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F1720),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1720),
        foregroundColor: Colors.white,
        title: const Text('AI local guide'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2B36),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ListView.separated(
                  itemCount: chatMessages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final message = chatMessages[index];
                    final isUser = message.$1 == 'You';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 280),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isUser ? const Color(0xFF7EC7F7) : const Color(0xFF101B22),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          message.$2,
                          style: TextStyle(
                            color: isUser ? const Color(0xFF0F1720) : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Ask about local rules…',
                      hintStyle: const TextStyle(color: Color(0xFF9FB7C7)),
                      filled: true,
                      fillColor: const Color(0xFF1F2B36),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF7EC7F7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.send, color: Color(0xFF0F1720)),
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
