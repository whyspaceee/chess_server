import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chess_socket_server/enums/enums.dart';
import 'package:chess_socket_server/models/board.dart';
import 'package:chess_socket_server/models/message.dart';

class Client {
  final Socket _socket;
  final Function(Message, Client) messageHandler;
  late String _address;
  late int _port;
  late Board board;
  late int gameNumber;

  Client(this._socket, this.messageHandler) {
    _address = _socket.remoteAddress.address;
    _port = _socket.remotePort;

    _socket.listen(jsonParser, onDone: finishedHandler, onError: errorHandler);
  }

  void jsonParser(Uint8List data) {
    String rawMessage = String.fromCharCodes(data).trim();
    Map<String, dynamic> json = jsonDecode(rawMessage);
    Message message = Message.fromJSON(json);
    messageHandler(message, this);
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
