class ChatListModel {
  final String chatId;
  final String otherUserId;
  final String lastMessage;
  final DateTime? updatedAt;

  ChatListModel({
    required this.chatId,
    required this.otherUserId,
    required this.lastMessage,
    required this.updatedAt,
  });
}
