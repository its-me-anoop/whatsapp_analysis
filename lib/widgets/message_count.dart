// widgets/message_count.dart

import 'package:flutter/material.dart';
import 'package:whatsapp_analysis/models/chat_message.dart';

class MessageCountWidget extends StatelessWidget {
  final List<ChatMessage> chatMessages;

  const MessageCountWidget({super.key, required this.chatMessages});

  int getTotalMessageCount() {
    return chatMessages.length;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text('Total Messages'),
              Text(
                '${getTotalMessageCount()}',
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
