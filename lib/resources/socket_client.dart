// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

//singleton class
class SocketClient {
  IO.Socket? socket;
  static SocketClient? _instance;

//making internal construct such that no other isntance can get it
  SocketClient._internal() {
    socket = IO.io('https://typerracer-server.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
  }

  static SocketClient get instance {
    _instance ??= SocketClient._internal(); //calling first instance created
    return _instance!;
  }
}
