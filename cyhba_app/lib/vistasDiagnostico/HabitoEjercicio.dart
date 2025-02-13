import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HabitoEjercicioScreen extends StatefulWidget {
  @override
  _HabitoEjercicioScreenState createState() => _HabitoEjercicioScreenState();
}

class _HabitoEjercicioScreenState extends State<HabitoEjercicioScreen> {
  late String email;
  bool _initialized = false; // Para evitar múltiples asignaciones

  String? selectedActivity;
  String? selectedPhysical;

  final List<String> activityOptions = ['Moderado', 'Alto', 'Bajo'];
  final List<String> physicalOptions = ['Moderado', 'Alto', 'Bajo'];

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

  //funcion para actualizar el nivel de ejercicio y la actividad fisica
  Future<void> actualizarUsuarioHabitos(
      String nivelEjercicio, String actividadFisica) async {
    final url = Uri.parse("http://localhost:4000/updateExeLevel");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "nivelEjercicio": nivelEjercicio,
        "actividadFisica": actividadFisica
      }),
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
          'Hábitos de ejercicio',
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
                "El nivel de ejercicio se considera como una actividad planificada ¿Cuál es su nivel de ejercicio?",
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
                  value: selectedActivity,
                  isExpanded: true,
                  hint: Text("Nivel de ejercicio:"),
                  underline: SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedActivity = newValue;
                    });
                  },
                  items: activityOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "El nivel de actividad física se considera como una actividad no planificada ¿Cúal es su nivel de actividad física?",
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
                  value: selectedPhysical,
                  isExpanded: true,
                  hint: Text("Actividad física:"),
                  underline: SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPhysical = newValue;
                    });
                  },
                  items: physicalOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // if (_formKey.currentState?.validate() ?? false) {
                    actualizarUsuarioHabitos(
                      selectedActivity ?? "",
                      selectedPhysical ?? "",
                    );
                    Navigator.pushNamed(context, '/nivelDieta',
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
