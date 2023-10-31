class ChatMessage {
  final String text;
  final String sender;
  final String timeStamp;
  final String
      mediaType; // Add this property for media type (e.g., image, video, document)

  ChatMessage({
    required this.text,
    required this.sender,
    required this.timeStamp,
    required this.mediaType,
  });
}
