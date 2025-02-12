import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CigarrilloScreen extends StatefulWidget {
  @override
  _CigarrilloScreenState createState() => _CigarrilloScreenState();
}

class _CigarrilloScreenState extends State<CigarrilloScreen> {
  late String email;
  bool _initialized = false; // Para evitar múltiples asignaciones

  String? selectedSmoke;

  final List<String> smoking = ['Si', 'No'];

  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null && arguments is String) {
        setState(() {
          email = arguments;
          _initialized = true; // Evita asignar varias veces
        });
      } else {
        // Redirigir si no hay email
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  //funcion back para actualizar datos de la frecuencia
  Future<void> actualizarUsuarioSmoking(String cigarrillo) async {
    final url = Uri.parse("http://localhost:4000/updateSmoke");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "cigarrillo": cigarrillo,
      }),
    );

    if (response.statusCode == 200) {
      print("Datos actualizados correctamente");
    } else {
      print("Error al actualizar: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tabaco o afines',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/onlyheart.jpg'),
            ),
          )
        ],
        backgroundColor: Color(0xFF2A3038),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/Ejercicio.jpg',
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30),
              Text(
                "¿Usted fuma o suele fumar mucho?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  value: selectedSmoke,
                  isExpanded: true,
                  hint: Text("Tabaco o afines:"),
                  underline: SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSmoke = newValue;
                    });
                  },
                  items: smoking.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    actualizarUsuarioSmoking(selectedSmoke ?? '');
                    Navigator.pushNamed(context, '/resultado',
                        arguments: email);
                  },
                  child: Text("Siguiente"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
