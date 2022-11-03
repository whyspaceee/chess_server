import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chess_socket_server/enums/enums.dart';
import 'package:chess_socket_server/models/board.dart';
import 'package:chess_socket_server/models/client.dart';
import 'package:chess_socket_server/models/message.dart';

class Server {
  List<Client> clients = [];
  List<Board> boards = [];
  ServerSocket server;

  Server(this.server) {
    server.listen((client) {
      print('Connected ${client.address}');
      handleConnection(client);
    });
  }

  void handleConnection(Socket client) {
    clients.add(Client(client, messageHandler));
  }

  void messageHandler(Message message, Client client) {
    if (message.type == MessageType.create) {
      print('Create game');
      final newBoard = Board(message.message, message.gameNumber);
      client.board = newBoard;
      client.gameNumber = message.gameNumber;
      boards.add(newBoard);
    } else if (message.type == MessageType.join) {
      print('Join game ${message.gameNumber}');
      client.board = boards
          .firstWhere((element) => element.gameNumber == message.gameNumber);
      client.gameNumber = message.gameNumber;
    } else if (message.type == MessageType.move) {
      print('Move piece');
    } else if (message.type == MessageType.quit) {
      print('Quit game');
    }
  }
}
