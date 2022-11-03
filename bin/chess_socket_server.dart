import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chess_socket_server/models/server.dart';

void main(List<String> arguments) async {
  Server server =
      Server(await ServerSocket.bind(InternetAddress.anyIPv4, 4567));
}
