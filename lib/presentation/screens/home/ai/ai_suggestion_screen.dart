// ai_suggestion_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:yconic/domain/entities/clothe.dart';
import 'package:yconic/domain/entities/suggestion.dart';
import 'package:yconic/presentation/providers/auth/auth_provider.dart';
import 'package:yconic/presentation/providers/suggestion/suggestion_provider.dart';

class AiSuggestionScreen extends ConsumerStatefulWidget {
  const AiSuggestionScreen({super.key});

  @override
  ConsumerState<AiSuggestionScreen> createState() => _AiSuggestionScreenState();
}

class _AiSuggestionScreenState extends ConsumerState<AiSuggestionScreen> {
  List<Clothe> animatedClothes = [];

  Future<void> animateClothes(Suggestion suggestion) async {
    animatedClothes.clear();
    for (final item in suggestion.SuggestedLook) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => animatedClothes.add(item));
    }
  }

  Future<void> onGetSuggestionPressed() async {
    final user = ref.read(authNotifierProvider).user;
    if (user == null) return;
    await ref.read(suggestionProvider.notifier).createSuggestion(user.Id);
    final suggestion = ref.read(suggestionProvider).suggestion;
    if (suggestion != null) {
      await animateClothes(suggestion);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(suggestionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Suggestion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: state.isLoading ? null : onGetSuggestionPressed,
              child: const Text('Get Suggestion'),
            ),
            const SizedBox(height: 16),
            if (state.error != null)
              Text("Error: ${state.error}",
                  style: const TextStyle(color: Colors.red)),
            if (state.isLoading)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animations/ai_loading_suggestion.json',
                        height: 220,
                        repeat: true,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "AI is building your look...",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            else if (animatedClothes.isNotEmpty)
              Expanded(
                child: SuggestionCard(items: animatedClothes),
              )
          ],
        ),
      ),
    );
  }
}

class SuggestionCard extends StatelessWidget {
  final List<Clothe> items;

  const SuggestionCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("AI Generated Look",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...items.map((item) => ClotheCard(item: item)).toList(),
          ],
        ),
      ),
    );
  }
}

class ClotheCard extends StatelessWidget {
  final Clothe item;

  const ClotheCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = 'http://10.0.2.2:5000${item.MainPhoto}';
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(item.Name ?? 'Unnamed'),
        subtitle: Text(item.Brand ?? 'Unknown'),
      ),
    );
  }
}
