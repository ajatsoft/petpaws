import 'package:flutter/material.dart';
import 'package:petpaws/bloc/login_bloc.dart';
import 'package:petpaws/pages/calendar_reservation_page.dart';
import 'package:petpaws/pages/perfilVeterinarias_page.dart';
import 'package:petpaws/pages/reservaService_page.dart';
import 'package:petpaws/pages_veterinaria/calendar-events.dart';
import 'package:petpaws/pages_veterinaria/create-service.dart';
import 'package:petpaws/pages_veterinaria/horarios_atencion.dart';
import 'package:petpaws/screens/inicio.dart';
import 'package:provider/provider.dart';
//import 'package:petpaws/screens/login_screen.dart';
//import 'package:petpaws/screens/splash_screen.dart';

//import 'package:petpaws/screens/inicio.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:intl/date_symbol_data_local.dart';

// importamos wavesanimaction

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(MyApp());
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => LoginBloc(),
      child: MaterialApp(
          theme: ThemeData(
            primaryColor: Color(0xFF6600FF),
          ),
          title: 'login iu',
          debugShowCheckedModeBanner: false,
          //home: LoginScreen(),
          // home: Inicio(),
          initialRoute: '/',
          // home: LoginPage(),
          routes: {
            '/': (context) => Inicio(),
            'perfilveterinarias': (context) => PerfilVeterinariaPage(),
            'crearservico': (context) =>
                CreateServices(), //este es la pagina en el perfil de veterninarias
            'calendarPage': (context) => CalendarPage(),
            'horariosatencion': (context) => HorarioAtencion(),
            'ReservaService': (context) =>ReservaService(), //la pagina donde se llena el formulario para reservar cita
            'calendarevents': (context) =>MyCalendar(),
          }),
    );
  }
}
