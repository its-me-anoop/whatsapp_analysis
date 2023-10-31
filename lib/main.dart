import 'package:flutter/material.dart'; // Import the Flutter material package
import 'package:flutter/foundation.dart'
    show
        kIsWeb; // Import kIsWeb from flutter/foundation package for web detection
import 'package:whatsapp_analysis/screens/chat_screen.dart'; // Import the ChatScreen from your project

void main() {
  runApp(
    kIsWeb
        ? MaterialApp(
            home: const ChatScreen(
                chatMessages: []), // Use ChatScreen with empty chatMessages for web
            theme: ThemeData(useMaterial3: true), // Use Material3 theme for web
          )
        : MaterialApp(
            home: const ChatScreen(
                chatMessages: []), // Use ChatScreen with empty chatMessages for non-web
            theme: ThemeData(
                useMaterial3: true), // Use Material3 theme for non-web
          ),
  );
}
