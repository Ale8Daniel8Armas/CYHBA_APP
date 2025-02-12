import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EstadoSaludTwoScreen extends StatefulWidget {
  @override
  _EstadoSaludTwoScreenState createState() => _EstadoSaludTwoScreenState();
}

class _EstadoSaludTwoScreenState extends State<EstadoSaludTwoScreen> {
  late String email;
  bool _initialized = false; // Para evitar múltiples asignaciones

  // Controladores de los campos de texto

  final TextEditingController presionController = TextEditingController();

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

  //funcion back para actualizar datos del usuario por presion y colesterol
  Future<void> actualizarUsuarioPC(double presion) async {
    final url = Uri.parse("http://localhost:4000/updatePC");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "presion": presion}),
    );

    if (response.statusCode == 200) {
      print("Datos actualizados correctamente para la presion");
    } else {
      print("Error al actualizar: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Status Salud',
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
        backgroundColor: Color(0xFFF05E54),
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
                  'assets/EstadoSaludTwo.jpg',
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30),
              Text(
                "¿Cuál es tu valor de presión sanquínea (arterial)?",
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
                child: TextFormField(
                  controller: presionController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Ingresa tu presión sanquínea [mmHg]:",
                    border: InputBorder.none,
                  ),
                  /*validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu edad';
                    }
                    int? age = int.tryParse(value);
                    if (age == null || age < 18 || age > 80) {
                      return 'Edad debe ser un número entre 18 y 80';
                    }
                    return null;
                  },*/
                ),
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // if (_formKey.currentState?.validate() ?? false) {
                    actualizarUsuarioPC(
                      double.parse(presionController.text),
                    );
                    Navigator.pushNamed(context, '/habitoEjercicios',
                        arguments: email);
                    // }
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
