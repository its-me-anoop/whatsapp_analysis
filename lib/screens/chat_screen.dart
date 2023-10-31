// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:whatsapp_analysis/models/chat_message.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:whatsapp_analysis/widgets/media_analysis.dart';
import 'package:whatsapp_analysis/widgets/message_count.dart';
import 'package:whatsapp_analysis/widgets/user_message_count.dart';
import 'package:whatsapp_analysis/widgets/word_frequency.dart';

class ChatScreen extends StatefulWidget {
  final List<ChatMessage> chatMessages;

  const ChatScreen({super.key, required this.chatMessages});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> chatMessages = [];

  bool isImportingData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp Chat Analysis'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isImportingData = true;
                  });

                  // Trigger the import process
                  _importChatData().then((messages) {
                    setState(() {
                      chatMessages = messages;
                      isImportingData = false;
                    });
                  });
                },
                child: const Text(
                  "Import Chat Data",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (isImportingData)
              const CircularProgressIndicator()
            else if (chatMessages.isNotEmpty)
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    MessageCountWidget(chatMessages: chatMessages),
                    MediaAnalysisWidget(chatMessages: chatMessages),
                    WordFrequencyAnalysisWidget(chatMessages: chatMessages),
                    MessageCountAnalysisWidget(chatMessages: chatMessages)
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<List<ChatMessage>> _importChatData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      if (kIsWeb) {
        String fileContent = String.fromCharCodes(result.files.single.bytes!);
        final List<String> chatData = fileContent.split('\n');
        return parseChatData(chatData);
      } else {
        String filePath = result.files.single.path!;
        String fileContent = File(filePath).readAsStringSync();
        final List<String> chatData = fileContent.split('\n');
        return parseChatData(chatData);
      }
    } else {
      throw Exception("No file selected");
    }
  }

  List<ChatMessage> parseChatData(List<String> chatData) {
    List<ChatMessage> messages = [];

    final emojiParser = EmojiParser();

    String currentTimestamp = "";
    String currentParticipant = "";
    String currentMessage = "";

    for (String line in chatData) {
      if (line.isNotEmpty) {
        if (line.startsWith("[") && line.contains("] ")) {
          String timestamp = line.split("] ")[0].substring(1);
          String participant = line.split("] ")[1].split(": ")[0];
          String message =
              emojiParser.emojify(line.split("] ")[1].split(": ")[1]);

          if (currentTimestamp.isNotEmpty && currentParticipant.isNotEmpty) {
            messages.add(ChatMessage(
              text: currentMessage,
              sender: currentParticipant,
              timeStamp: currentTimestamp,
              mediaType: "text",
            ));
          }

          currentTimestamp = timestamp;
          currentParticipant = participant;
          currentMessage = message;
        } else {
          currentMessage += "\n${emojiParser.emojify(line)}";
        }
      }
    }

    if (currentTimestamp.isNotEmpty && currentParticipant.isNotEmpty) {
      messages.add(ChatMessage(
        text: currentMessage,
        sender: currentParticipant,
        timeStamp: currentTimestamp,
        mediaType: "text",
      ));
    }

    return messages;
  }
}
