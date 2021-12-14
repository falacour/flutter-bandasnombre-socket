import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerEstado { Online, Offline, Connecting }

class SocketProvider with ChangeNotifier {
  ServerEstado _serverEstado = ServerEstado.Connecting;
  IO.Socket? _socket;

  //Function get emit => this._socket!.emit;

  ServerEstado get serverEstado => this._serverEstado;
  
  IO.Socket get socket => this._socket!;

  SocketProvider() {
    this._configInicial();
  }

  void _configInicial() {
// Dart client
    this._socket = IO.io('http://192.168.0.5:3000/', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    this._socket!.on('connect', (_) {
      print('connect');
      this._serverEstado = ServerEstado.Online;
      notifyListeners();
    });

    this._socket!.on('disconnect', (_) {
      print('disconnect');
      this._serverEstado = ServerEstado.Offline;
      notifyListeners();
    });

    //escuchar mensaje de una pagina web en el servidor
    // socket.on('nuevo-mensaje', (payload) {
    //   //print('nuevo-mensaje: $payload');
    //   print('Nombre : ' + payload['nombre']);
    //   print('Mensaje : ' + payload['mensaje']);
    //   print(payload.containsKey('mensaje2') ? 'Mensaje 2 : ' + payload['mensaje2'] : 'No hay mensaje 2');
    // });

    
  }
}
