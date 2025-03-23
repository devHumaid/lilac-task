class ChatMessage {
  final String id;
  final String type;
  final ChatMessageAttributes attributes;

  ChatMessage({
    required this.id,
    required this.type,
    required this.attributes,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      attributes: ChatMessageAttributes.fromJson(json['attributes'] ?? {}),
    );
  }
}

class ChatMessageAttributes {
  final int chatThreadId;
  final int chatMessageTypeId;
  final String senderId;
  final String receiverId;
  final String? message;
  final MediaMeta? mediaMeta;
  final String? mediaUrl;
  final String sentAt;
  final String? deliveredAt;
  final String? viewedAt;

  ChatMessageAttributes({
    required this.chatThreadId,
    required this.chatMessageTypeId,
    required this.senderId,
    required this.receiverId,
    this.message,
    this.mediaMeta,
    this.mediaUrl,
    required this.sentAt,
    this.deliveredAt,
    this.viewedAt,
  });

  factory ChatMessageAttributes.fromJson(Map<String, dynamic> json) {
    return ChatMessageAttributes(
      chatThreadId: json['chat_thread_id'] ?? 0,
      chatMessageTypeId: json['chat_message_type_id'] ?? 0,
      senderId: json['sender_id']?.toString() ?? '',
      receiverId: json['receiver_id']?.toString() ?? '',
      message: json['message'],
      mediaMeta: json['media_meta'] != null
          ? MediaMeta.fromJson(json['media_meta'])
          : null,
      mediaUrl: json['media_url'],
      sentAt: json['sent_at'] ?? '',
      deliveredAt: json['delivered_at'],
      viewedAt: json['viewed_at'],
    );
  }
}

class MediaMeta {
  final String fileData;
  final String? mimeType;
  final int? fileSize;

  MediaMeta({
    required this.fileData,
    this.mimeType,
    this.fileSize,
  });

  factory MediaMeta.fromJson(Map<String, dynamic> json) {
    return MediaMeta(
      fileData: json['file_data'] ?? '',
      mimeType: json['mime_type'],
      fileSize: json['file_size'],
    );
  }
}
