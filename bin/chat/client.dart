import 'dart:io';
import 'dart:convert';

void main() async {
  final socket = await Socket.connect('127.0.0.1', 4040);
  print('Connected to the chat server. Set your username with /username [YourName]');

  socket.listen((data) {
    print(utf8.decode(data).trim());
  }, onDone: () {
    print('Disconnected from the server.');
    exit(0);
  });

  var input = '';
  while (true) {
    input = stdin.readLineSync() ?? '';
    if (input.isNotEmpty) {
      socket.write('$input\n');
      if (input.toLowerCase() == '/quit') {
        await socket.close();
        exit(0);
      }
    }
  }
}
