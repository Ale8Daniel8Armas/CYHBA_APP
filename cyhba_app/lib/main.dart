import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'registrationPage.dart';
import '../vistasPerfil/edadGeneroPage.dart';
import '../vistasPerfil/saludHistoricaPage.dart';
import '../vistasPerfil/localidadOcupacionPage.dart';
import '../vistasDiagnostico/EstadoSaludUno.dart';
import '../vistasDiagnostico/EstadoSaludDos.dart';
import '../vistasDiagnostico/HabitoEjercicio.dart';
import '../vistasDiagnostico/NivelDieta.dart';
import '../vistasDiagnostico/NivelEstres.dart';
import '../vistasDiagnostico/EstadoCorazon.dart';
import '../vistasDiagnostico/tiposBebida.dart';
import '../vistasDiagnostico/CantidaAlcohol.dart';
import '../vistasDiagnostico/FrecuenciaAlcohol.dart';
import '../vistasDiagnostico/CigarrilloPage.dart';
import '../resultadosPage.dart';
import 'homePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cyhba App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/registration': (context) => RegisterPage(),
        '/edadGenero': (context) => EdadGeneroPageScreen(),
        '/localidadOcupacion': (context) => LocalidadOcupacionPageScreen(),
        '/saludHistorica': (context) => saludHistoricaPageScreen(),
        '/estadoSaludUno': (context) => EstadoSaludOneScreen(),
        '/estadoSaludDos': (context) => EstadoSaludTwoScreen(),
        '/habitoEjercicios': (context) => HabitoEjercicioScreen(),
        '/nivelDieta': (context) => NivelDietaScreen(),
        '/nivelEstres': (context) => NivelEstresScreen(),
        '/estadoCorazon': (context) => EstadoCorazonScreen(),
        '/tiposBebida': (context) => BeverageSelectionPage(),
        '/cantidadAlcohol': (context) => CantidadConsumoScreen(),
        '/frecuencia': (context) => FrecuenciaScreen(),
        '/tabaco': (context) => CigarrilloScreen(),
        '/resultado': (context) => ResultadosScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
