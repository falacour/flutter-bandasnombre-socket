import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bandas_nombre/src/pages/estado_page.dart';
import 'package:bandas_nombre/src/pages/home.dart';
import 'package:bandas_nombre/src/provider/socket_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': (_) => HomePage(),
          'estado': (_) => EstadoPage(),
        },
      ),
    );
  }
}
