import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EstadoCorazonScreen extends StatefulWidget {
  @override
  _EstadoCorazonScreenState createState() => _EstadoCorazonScreenState();
}

class _EstadoCorazonScreenState extends State<EstadoCorazonScreen> {
  late String email;
  bool _initialized = false; // Para evitar múltiples asignaciones

  String? selectedAttack;
  int heartRate = 80;

  final List<String> attackOptions = ['Si', 'No'];

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

  //funcion back para actualizar datos del estado del corazon
  Future<void> actualizarUsuarioPorCorazon(
      String ataqueCardiaco, int ratioCorazon) async {
    final url = Uri.parse("http://localhost:4000/updateHeart");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "ataqueCardiaco": ataqueCardiaco,
        "ratioCorazon": ratioCorazon,
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
          'Estado del corazón',
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
                "¿Has sufrido un ataque al corazón antes?",
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
                  value: selectedAttack,
                  isExpanded: true,
                  hint: Text("Ataque al corazón:"),
                  underline: SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAttack = newValue;
                    });
                  },
                  items: attackOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "¿Cuál sería el nivel del pulso de su corazón ahora mismo?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slider(
                    value: heartRate.toDouble(),
                    min: 60,
                    max: 120,
                    divisions: 40,
                    label: heartRate.toString(),
                    onChanged: (double value) {
                      setState(() {
                        heartRate = value.toInt();
                      });
                    },
                  ),
                  Text(
                    "Valor estimado: ${heartRate.toString()} pulsadas",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //print("Ingesta diaria seleccionada: $waterIntake litros");
                    actualizarUsuarioPorCorazon(
                        selectedAttack ?? "", heartRate);
                    Navigator.pushNamed(context, '/tiposBebida',
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
