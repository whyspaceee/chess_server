import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

enum MessageType { create, join, move, quit }

void main(List<String> arguments) {}

class Client {
  final Socket _socket;
  late String _address;
  late int _port;

  Client(this._socket) {
    _address = _socket.remoteAddress.address;
    _port = _socket.remotePort;

    _socket.listen(messageHandler);
  }

  void messageHandler(Uint8List data) {
    String rawMessage = String.fromCharCodes(data).trim();
    Map<String, dynamic> json = jsonDecode(rawMessage);
    Message message = Message.fromJSON(json);
  }

  void errorHandler(error) {
    print('$_address:$_port Error: $error');
    _socket.close();
  }

  void finishedHandler() {
    print('$_address:$_port Disconnected');
    _socket.close();
  }
}

class Message {
  MessageType type;
  String message;

  Message(this.message, this.type);

  Map<String, dynamic> toJSON() => {'message': message, 'type': type.index};

  String toString() => jsonEncode(toJSON());

  factory Message.fromJSON(Map<String, dynamic> json) =>
      Message(json['message'], MessageType.values[json['type']]);
}
