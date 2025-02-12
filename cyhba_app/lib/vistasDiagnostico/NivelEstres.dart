import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NivelEstresScreen extends StatefulWidget {
  @override
  _NivelEstresScreenState createState() => _NivelEstresScreenState();
}

class _NivelEstresScreenState extends State<NivelEstresScreen> {
  late String email;
  bool _initialized = false; // Para evitar múltiples asignaciones

  String? selectedEstresLevel;
  double sleepHours = 7.0;

  final List<String> levelEstresOptions = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];

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

  //funcion back para actualizar datos del nivel de estres y horas de sueño
  Future<void> actualizarUsuarioPorEstres(
      int estres, double horasSuenio) async {
    final url = Uri.parse("http://localhost:4000/updateStress");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "estres": estres,
        "horasSuenio": horasSuenio,
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
          'Nivel de estrés',
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
                "Del 1 al 10 (1 como bajo y 10 como alto) ¿Cúal sería su nivel de estrés?",
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
                  value: selectedEstresLevel,
                  isExpanded: true,
                  hint: Text("Nivel de estrés:"),
                  underline: SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedEstresLevel = newValue;
                    });
                  },
                  items: levelEstresOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "¿Cuántas horas duerme en la noche regularmente?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: sleepHours,
                    min: 4.0,
                    max: 10.0,
                    divisions: 40, // Incrementos de 0.1
                    label:
                        sleepHours.toStringAsFixed(1), // Etiqueta con decimales
                    onChanged: (double value) {
                      setState(() {
                        sleepHours = value;
                      });
                    },
                  ),
                  Text(
                    "Horas de sueño: ${sleepHours.toStringAsFixed(1)} horas",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //print("Ingesta diaria seleccionada: $waterIntake litros");
                    actualizarUsuarioPorEstres(
                        int.tryParse(selectedEstresLevel ?? "") ?? 1,
                        sleepHours);
                    Navigator.pushNamed(context, '/estadoCorazon',
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
