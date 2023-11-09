import 'dart:io';
import 'dart:convert';

void main() async {
  final server = await ServerSocket.bind('127.0.0.1', 4040);
  final clients = <Socket>[];
  final Map<Socket, String> usernames = {};
  print('Chat server is running on ${server.address}:${server.port}');

  await for (var client in server) {
    print('New client connected');
    clients.add(client);
    usernames[client] = 'User ${client.remoteAddress.address}:${client.remotePort}';

    client.listen((data) {
      var message = utf8.decode(data).trim();
      var username = usernames[client]!;
      if (message.startsWith('/username')) {
        var newUsername = message.replaceFirst('/username ', '');
        usernames[client] = newUsername;
        print('Welcome to the chat, $newUsername!\n');
      } else {
        for (var otherClient in clients) {
          if (otherClient != client) {
            otherClient.write('$username: $message\n');
          }
        }
        print('$username: $message');
      }
    }, onDone: () {
      clients.remove(client);
      usernames.remove(client);
      print('Client disconnected');
    });
  }
}
