import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:whatsapp_analysis/screens/chat_screen.dart'; // Import conditional library

void main() {
  runApp(kIsWeb
      ? MaterialApp(
          home: const ChatScreen(chatMessages: []),
          theme: ThemeData(useMaterial3: true),
        )
      : MaterialApp(
          home: const ChatScreen(chatMessages: []),
          theme: ThemeData(useMaterial3: true),
        ));
}
