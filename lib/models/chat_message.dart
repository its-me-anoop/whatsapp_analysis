class ChatMessage {
  final String text; // The text of the chat message
  final String sender; // The sender of the chat message
  final String timeStamp; // The timestamp of the chat message
  final String
      mediaType; // The media type of the message (e.g., image, video, document)

  ChatMessage({
    required this.text, // The text content of the message
    required this.sender, // The sender's name or identifier
    required this.timeStamp, // The timestamp when the message was sent
    required this.mediaType, // The type of media in the message (e.g., image, video, document)
  });
}
