import 'package:flutter/material.dart';
import 'package:whatsapp_analysis/models/chat_message.dart';

class MessageCountAnalysisWidget extends StatefulWidget {
  final List<ChatMessage> chatMessages;

  const MessageCountAnalysisWidget({Key? key, required this.chatMessages})
      : super(key: key);

  @override
  MessageCountAnalysisWidgetState createState() =>
      MessageCountAnalysisWidgetState();
}

class MessageCountAnalysisWidgetState
    extends State<MessageCountAnalysisWidget> {
  List<MapEntry<String, int>> messageCountList = [];

  @override
  void initState() {
    super.initState();
    _calculateMessageCount();
  }

  void _calculateMessageCount() {
    final messageCountMap = {};

    for (final message in widget.chatMessages) {
      final sender = message.sender;
      messageCountMap[sender] = (messageCountMap[sender] ?? 0) + 1;
    }

    final messageCountListDynamic = messageCountMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Limit the list to the top 25 users
    messageCountList = messageCountListDynamic
        .take(25)
        .toList()
        .map((entry) => MapEntry<String, int>(entry.key, entry.value))
        .toList();
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
            const Text('Top 25 Users by Message Count',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            SizedBox(
              height: 300, // Adjust the height as needed
              child: BarChart(
                messageCountList: messageCountList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarChart extends StatelessWidget {
  final List<MapEntry<String, int>> messageCountList;

  const BarChart({super.key, required this.messageCountList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messageCountList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final sender = messageCountList[index].key;
        final count = messageCountList[index].value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SizedBox(
                width: 300,
                child: Text(
                  sender,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: count.toDouble(), // Adjust the width as needed
                    height: 20,
                    color: Colors.blue.withAlpha(255 - index * 12),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    count.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
