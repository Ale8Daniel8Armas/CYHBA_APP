import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NivelDietaScreen extends StatefulWidget {
  @override
  _NivelDietaScreenState createState() => _NivelDietaScreenState();
}

class _NivelDietaScreenState extends State<NivelDietaScreen> {
  late String email;
  bool _initialized = false; // Para evitar múltiples asignaciones

  String? selectedDiet;
  double waterIntake = 3.0;

  final List<String> dietOptions = ['Saludable', 'Regular', 'No Saludable'];

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

  //funcion back para actualizar datos del nivel de dieta y consumo de agua
  Future<void> actualizarUsuarioDietaAgua(
      String nivelDieta, double consumoAgua) async {
    final url = Uri.parse("http://localhost:4000/updateDietWater");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "nivelDieta": nivelDieta,
        "consumoAgua": consumoAgua,
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
          'Nivel de dieta',
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
                  'assets/Ejercicio.jpg',
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30),
              Text(
                "¿Cómo considera su dieta?",
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
                  value: selectedDiet,
                  isExpanded: true,
                  hint: Text("Nivel de dieta:"),
                  underline: SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDiet = newValue;
                    });
                  },
                  items: dietOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "¿Cuál es su cantidad de ingesta diaria de agua?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: waterIntake,
                    min: 1.0,
                    max: 5.0,
                    divisions: 40, // Incrementos de 0.1
                    label: waterIntake
                        .toStringAsFixed(1), // Etiqueta con decimales
                    onChanged: (double value) {
                      setState(() {
                        waterIntake = value;
                      });
                    },
                  ),
                  Text(
                    "Ingesta diaria: ${waterIntake.toStringAsFixed(1)} litros",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //print("Ingesta diaria seleccionada: $waterIntake litros");
                    actualizarUsuarioDietaAgua(selectedDiet ?? "", waterIntake);
                    Navigator.pushNamed(context, '/nivelEstres',
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
