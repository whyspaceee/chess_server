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
      if (client.gameNumber == message.gameNumber) {
        print('already in game');
        client.socket.write(Message(client.board.fenState, MessageType.move,
            client.gameNumber, message.isWhite));
        return;
      }
      print('Create game');
      final newBoard = Board(message.message, message.gameNumber);
      client.board = newBoard;
      client.gameNumber = message.gameNumber;
      boards.add(newBoard);
      print(newBoard.fenState + newBoard.gameNumber.toString());
    } else if (message.type == MessageType.join) {
      if (client.gameNumber == message.gameNumber) {
        print('Already in game');
        client.socket.write(Message(client.board.fenState, MessageType.move,
            client.gameNumber, message.isWhite));
        return;
      }
      print('Join game ${message.gameNumber}');
      client.board = boards
          .firstWhere((element) => element.gameNumber == message.gameNumber);
      client.gameNumber = message.gameNumber;
      for (var c in clients) {
        if (c != client) {
          c.socket.write(Message(
              'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 1 2',
              MessageType.join,
              message.gameNumber,
              message.isWhite));
        }
      }
    } else if (message.type == MessageType.move) {
      print('Move piece ${message.message}');
      client.board.fenState = message.message;
      for (var c in clients) {
        if (c != client && c.gameNumber == message.gameNumber) {
          c.socket.write(Message(message.message, MessageType.move,
              message.gameNumber, !message.isWhite));
        }
      }
    } else if (message.type == MessageType.quit) {
      print('Quit game');
      boards.removeWhere((element) => element.gameNumber == message.gameNumber);
      clients
          .removeWhere((element) => element.gameNumber == message.gameNumber);
    }
  }
}
