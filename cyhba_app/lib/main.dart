import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'registrationPage.dart';
import '../vistasPerfil/edadGeneroPage.dart';
import '../vistasPerfil/saludHistoricaPage.dart';
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
        '/edadGenero': (context) => edadGeneroPageScreen(),
        '/saludHistorica': (context) => saludHistoricaPageScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
