import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AIService {
  AIService._();

  static final instance = AIService._();

  ChatSession? _chat;

  ChatSession get _session {
    final existingSession = _chat;
    if (existingSession != null) return existingSession;

    if (Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized.');
    }

    final model = FirebaseAI.googleAI(
      auth: FirebaseAuth.instance,
    ).generativeModel(
      model: 'gemini-1.5-flash', // Use gemini-1.5-flash for stable compatibility
      systemInstruction: Content.system(
        'You are CivicHaven AI Guide, a careful community safety assistant. '
        'Give practical, calm, concise guidance about personal safety, scams, '
        'reporting incidents, and local regulations. Keep answers short and clear.',
      ),
    );

    final session = model.startChat();
    _chat = session;
    return session;
  }

  Future<String> ask(String prompt) async {
    final response = await _session.sendMessage(Content.text(prompt));
    return response.text ?? 'No response received from AI Guide.';
  }

  void resetChat() {
    _chat = null;
  }
}