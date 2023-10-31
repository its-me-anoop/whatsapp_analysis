import 'package:flutter/material.dart';
import 'package:whatsapp_analysis/models/chat_message.dart';

class WordFrequencyAnalysisWidget extends StatefulWidget {
  final List<ChatMessage> chatMessages;

  const WordFrequencyAnalysisWidget({Key? key, required this.chatMessages})
      : super(key: key);

  @override
  WordFrequencyAnalysisWidgetState createState() =>
      WordFrequencyAnalysisWidgetState();
}

class WordFrequencyAnalysisWidgetState
    extends State<WordFrequencyAnalysisWidget> {
  late List<MapEntry<String, int>> sortedWordFrequencyList;
  late Future<void> wordFrequencyFuture;

  @override
  void initState() {
    super.initState();
    wordFrequencyFuture = _calculateWordFrequency();
  }

  Future<void> _calculateWordFrequency() async {
    final stopWords = <String>{
      'the',
      'and',
      'is',
      'it',
      'this',
      'was',
      'you',
      'to',
      // Add more stop words here
    };

    final wordFrequencyMap = <String, int>{};

    for (final message in widget.chatMessages) {
      final cleanedText = message.text.replaceAll(RegExp(r'^[^:]+: '), '');
      final cleanedTextWithoutAttachments =
          cleanedText.replaceAll(RegExp(r'<[^>]*>'), '');

      final words = cleanedTextWithoutAttachments.split(RegExp(r'\s+'));
      for (final word in words) {
        // Remove words consisting of digits or starting with digits
        if (!RegExp(r'^\d*$').hasMatch(word) &&
            !RegExp(r'^\d.*').hasMatch(word)) {
          final cleanedWord =
              word.replaceAll(RegExp(r'[^a-zA-Z]'), '').toLowerCase();
          if (cleanedWord.isNotEmpty && !stopWords.contains(cleanedWord)) {
            wordFrequencyMap[cleanedWord] =
                (wordFrequencyMap[cleanedWord] ?? 0) + 1;
          }
        }
      }
    }

    sortedWordFrequencyList = wordFrequencyMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Center(
              child: Text('Word Frequency Analysis',
                  style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: FutureBuilder<void>(
                future: wordFrequencyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return Expanded(
                      child: Wrap(
                        spacing: 10, // Adjust the spacing between chips
                        runSpacing: 10, // Adjust the run (line) spacing
                        children: sortedWordFrequencyList.take(25).map((entry) {
                          final word = entry.key;
                          final frequency = entry.value;
                          return Chip(
                            label: Text('$word - $frequency times'),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
