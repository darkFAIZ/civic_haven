import 'package:flutter/material.dart';

import '../services/ai_service.dart';

class AIGuidePage extends StatefulWidget {
  const AIGuidePage({super.key});

  @override
  State<AIGuidePage> createState() => _AIGuidePageState();
}

class _ChatMessage {
  const _ChatMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}

class _AIGuidePageState extends State<AIGuidePage> {
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final messages = <_ChatMessage>[
    const _ChatMessage(
      text: 'Hi, I am your CivicHaven safety guide. Ask me about scams, rentals, reporting an incident, or staying safe.',
      isUser: false,
    ),
  ];
  bool sending = false;

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final prompt = messageController.text.trim();
    if (prompt.isEmpty || sending) return;

    messageController.clear();
    setState(() {
      messages.add(_ChatMessage(text: prompt, isUser: true));
      sending = true;
    });
    _scrollToBottom();

    try {
      final answer = await AIService.instance.ask(prompt);
      if (!mounted) return;
      setState(() {
        messages.add(_ChatMessage(text: answer, isUser: false));
        sending = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        messages.add(const _ChatMessage(
          text: 'I could not reach Gemini right now. Check that Firebase AI Logic is enabled for this project and try again.',
          isUser: false,
        ));
        sending = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  controller: scrollController,
                  itemCount: messages.length + (sending ? 1 : 0),
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(14),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    final message = messages[index];
                    return Align(
                      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: message.isUser ? const Color(0xFF7EC7F7) : const Color(0xFF101B22),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: message.isUser ? const Color(0xFF0F1720) : Colors.white,
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    enabled: !sending,
                    minLines: 1,
                    maxLines: 4,
                    onSubmitted: (_) => sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Ask about safety...',
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
                    color: sending ? const Color(0xFF52616B) : const Color(0xFF7EC7F7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    onPressed: sending ? null : sendMessage,
                    tooltip: 'Send message',
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
