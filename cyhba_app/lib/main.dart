import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String?> _tokenFuture;

  @override
  void initState() {
    super.initState();
    _tokenFuture = _getToken();
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cyhba App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/registration': (context) => RegisterPage(),
        '/edadGenero': (context) => EdadGeneroPageScreen(token:_getToken()),
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
      home: FutureBuilder<String?>(
        future: _tokenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError || snapshot.data == null || JwtDecoder.isExpired(snapshot.data!)) {
            return LoginPage();
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });
            return EdadGeneroPageScreen(token: snapshot.data!);
          }
        },
      ),
    );
  }
}