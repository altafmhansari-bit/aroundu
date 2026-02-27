class ChatModel {
  final String id;
  final String name;
  final String lastMessage;
  final String image;
  final bool isOnline;

  ChatModel({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.image,
    required this.isOnline,
  });
}
