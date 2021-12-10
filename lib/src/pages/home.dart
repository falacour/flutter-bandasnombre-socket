import 'dart:io';

import 'package:bandas_nombre/src/models/banda.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Banda> bandas = [
    Banda(id: '1', nombre: 'Metallica', votos: 5),
    Banda(id: '2', nombre: 'Queen', votos: 2),
    Banda(id: '3', nombre: 'Heroes del silencio', votos: 1),
    Banda(id: '4', nombre: 'Bon Jovi', votos: 5),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BandasName', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bandas.length,
        itemBuilder: (context, i) => _bandaTile(bandas[i]),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: Icon(Icons.add),
        onPressed: () {
          agregarNuevaBanda();
        },
      ),
    );
  }

  Widget _bandaTile(Banda banda) {
    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direccion: $direction');
        //llamar al borrado en el server
      },
      background: Container(
        padding: EdgeInsets.only(left: 5),
        color: Colors.red,
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Borrar banda',
              style: TextStyle(color: Colors.white),
            )),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(banda.nombre.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(banda.nombre),
        trailing: Text(
          '${banda.votos}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          print(banda.nombre);
        },
      ),
    );
  }

  agregarNuevaBanda() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Nombre Nueva Banda: '),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                  child: Text('Agregar'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => agregarBandaLista(textController.text),
                ),
              ],
            );
          });
    }
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Nombre Nueva Banda'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Agregar'),
              onPressed: () => agregarBandaLista(textController.text),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Salir'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  void agregarBandaLista(String nombre) {
    print(nombre);
    if (nombre.length > 1) {
      this.bandas.add(new Banda(id: DateTime.now().toString(), nombre: nombre, votos: 0));
      setState(() {});
    } else {
      //esta vacio
    }

    Navigator.pop(context);
  }
}
