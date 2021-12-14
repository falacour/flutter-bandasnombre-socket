import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:bandas_nombre/src/models/banda.dart';
import 'package:bandas_nombre/src/provider/socket_provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Banda> bandas = [
    // Banda(id: '1', nombre: 'Metallica', votos: 5),
    // Banda(id: '2', nombre: 'Queen', votos: 2),
    // Banda(id: '3', nombre: 'Heroes del silencio', votos: 1),
    // Banda(id: '4', nombre: 'Bon Jovi', votos: 5),
  ];

  @override
  void initState() {
    //solo se ejecuta una vez cuando se inicializa
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    socketProvider.socket.on('bandas-activas', _traerBandasActivas);
    super.initState();
  }

  _traerBandasActivas(dynamic payload) {
    this.bandas = (payload as List) //transforma cada uno de los valores en listado
        .map((banda) => Banda.fromMap(banda)) // crea una instancia de cada uno de los objetos del mapa
        .toList(); //pasar el iterable a una lista

    setState(() {});
  }

  @override
  void dispose() {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    socketProvider.socket.off('bandas-activas');

    super.dispose();
  }

  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('BandasName', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketProvider.socket.connected)
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red),
          ),
        ],
      ),
      body: Column(
        children: [
          (bandas.isNotEmpty) ? _mostrarGrafica()! : Container(),
          Expanded(
            child: ListView.builder(
              //shrinkWrap: true,
              itemCount: bandas.length,
              itemBuilder: (context, i) => _bandaTile(bandas[i]),
            ),
          ),
        ],
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
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);

    return Dismissible(
      //key: Key(banda.id),
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketProvider.socket.emit('borrar-banda', {'id': banda.id}),

      background: Container(
        padding: EdgeInsets.only(left: 5),
        color: Colors.red,
        child: const Align(
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
            setState(() {
              socketProvider.socket.emit('agregar-voto', {'id': banda.id});
            });
          }),
    );
  }

  agregarNuevaBanda() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
        ),
      );
    }
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
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
      ),
    );
  }

  void agregarBandaLista(String nombre) {
    if (nombre.length > 1) {
      final socketProvider = Provider.of<SocketProvider>(context, listen: false);

      socketProvider.socket.emit('agregar-banda', {'nombre': nombre});
    } else {
      print('Debe agregar un nombre valido');
    }

    Navigator.pop(context);
  }

  Widget? _mostrarGrafica() {
    Map<String, double> dataMap = {};
    bandas.forEach((banda) {
      dataMap.putIfAbsent(banda.nombre, () => banda.votos.toDouble());
    });

    final List<Color> colorList = [
      Colors.blue.shade50,
      Colors.blue.shade200,
      Colors.pink.shade50,
      Colors.pink.shade200,
      Colors.yellow.shade50,
      Colors.yellow.shade200,
      Colors.green.shade50,
      Colors.green.shade200,
    ];

    return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        height: 200,
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          //chartLegendSpacing: 32,
          //chartRadius: MediaQuery.of(context).size.width / 2.7,
          colorList: colorList,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          //ringStrokeWidth: 32,
          //centerText: "HYBRID",
          legendOptions: const LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            //legendShape: _BoxShape.circle,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValueBackground: false,
            showChartValues: true,
            showChartValuesInPercentage: true,
            showChartValuesOutside: false,
            decimalPlaces: 1,
          ),
          // gradientList: ---To add gradient colors---
          // emptyColorGradient: ---Empty Color gradient---
        ));
  }
}
