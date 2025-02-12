import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EstadoSaludOneScreen extends StatefulWidget {
  @override
  _EstadoSaludOneScreenState createState() => _EstadoSaludOneScreenState();
}

class _EstadoSaludOneScreenState extends State<EstadoSaludOneScreen> {
  late String email;
  bool _initialized = false; // Para evitar múltiples asignaciones

  // Controladores de los campos de texto
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();

  // Para manejar la validación del formulario
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

  // Función para actualizar el BMI en el backend
  Future<void> actualizarBMI() async {
    final url = 'http://localhost:4000/updatePA';
    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      'email': email,
      'peso': double.tryParse(pesoController.text),
      'altura': double.tryParse(alturaController.text),
    });

    try {
      final response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status']) {
          // Si la actualización fue exitosa, muestra un mensaje
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('BMI actualizado correctamente!')),
          );
          // Aquí puedes navegar a otra pantalla si es necesario
          Navigator.pushNamed(context, '/estadoSaludDos', arguments: email);
        } else {
          // Si hubo un error, muestra un mensaje
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Error al actualizar el BMI: ${data['message']}')),
          );
        }
      } else {
        // Si el servidor no responde correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al contactar con el servidor')),
        );
      }
    } catch (error) {
      // Si hubo un error de red o cualquier otro error
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al realizar la solicitud')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Estado de Salud',
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
          ),
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
                  'assets/EstadoSaludOne.jpg',
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30),
              Text(
                "¿Cuál es tu peso?",
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
                  controller: pesoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Ingresa tu peso [kg]:",
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un peso válido';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 30),
              Text(
                "¿Cuál es tu altura?",
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
                  controller: alturaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Ingresa tu altura [m]:",
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una altura válida';
                    }
                    return null;
                  },
                ),
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Llamar al método para actualizar el BMI en el backend
                      actualizarBMI();
                    }
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
