import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'package:yotrabajo2/src/bloc/provider.dart';
import 'package:yotrabajo2/src/pages/detalle_trabajo_page.dart';
import 'package:yotrabajo2/src/pages/listado_page.dart';
import 'package:yotrabajo2/src/pages/perfil_page.dart';

import 'package:yotrabajo2/src/pages/empleado_page.dart';
import 'package:yotrabajo2/src/pages/home_page.dart';
import 'package:yotrabajo2/src/pages/login_page.dart';
import 'package:yotrabajo2/src/pages/registroEm_page.dart';
import 'package:yotrabajo2/src/providers/push_notifications_provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() { 
    super.initState();

    final pushProvider = new PushNotificationsProvider();
    pushProvider.initNotifications();

    pushProvider.mensajesStream.listen( (data) { 
      // print('argumento desde main: $argumento');
      // Navigator.pushNamed(context, 'mensaje');
      navigatorKey.currentState.pushNamed('mensaje', arguments: data);
    });
    
  }


  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), // English, no country code
          const Locale('es', 'ES'),
        ],
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          'Empleado': (BuildContext context) => EmpleadoPage(),
          'RegistroEmpleado': (BuildContext context) => RegistroEm(),
          'perfilEmpleado'  :(BuildContext context)=>PerfilPage(),
          'listado':(BuildContext context) => ListadoPage(),
          'detalle': (BuildContext context) =>DetalleTrabajoPage()
        },
        theme: ThemeData(
          primaryColor: Colors.lightBlue[100],
        ),
      ),
    );
  }
}
