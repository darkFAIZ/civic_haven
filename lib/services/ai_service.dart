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
      model: 'gemini-2.5-flash',
      systemInstruction: Content.system(
        'You are CivicHaven AI Guide, a careful community safety assistant. '
        'Give practical, calm, concise guidance about personal safety, scams, '
        'rentals, reporting incidents, and local resources. Do not claim to '
        'be emergency services. For immediate danger, tell the user to call '
        'their local emergency number. Never invent local laws or resources; '
        'say when location-specific information needs verification.',
      ),
    ).startChat();

    _chat = model;
    return model;
  }

  Future<String> ask(String prompt) async {
    final response = await _session.sendMessage(Content.text(prompt));
    final answer = response.text?.trim();
    if (answer == null || answer.isEmpty) {
      throw StateError('Gemini returned an empty response.');
    }
    return answer;
  }
}
