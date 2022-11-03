import 'dart:convert';

import 'package:chess_socket_server/enums/enums.dart';

class Message {
  MessageType type;
  int gameNumber;
  String message;

  Message(
    this.message,
    this.type,
    this.gameNumber,
  );

  Map<String, dynamic> toJSON() => {
        'message': message,
        'type': type.index,
        'gameNumber': gameNumber,
      };

  @override
  String toString() => jsonEncode(toJSON());

  factory Message.fromJSON(Map<String, dynamic> json) => Message(
      json['message'], MessageType.values[json['type']], json['gameNumber']);
}
