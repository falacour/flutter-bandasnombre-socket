import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bandas_nombre/src/provider/socket_provider.dart';

class EstadoPage extends StatelessWidget {
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Estado del servidor: ${socketProvider.serverEstado.name}')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          //enviar mensaje desde flutter a pagina web a travez del servidor
          socketProvider.socket.emit('emitir-mensaje', {'nombre': 'flutter', 'mensaje': 'hola desde flutter'});
        },
      ),
    );
  }
}
