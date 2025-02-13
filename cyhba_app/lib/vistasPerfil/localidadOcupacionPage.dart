import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LocalidadOcupacionPageScreen extends StatefulWidget {
  @override
  _LocalidadOcupacionPageScreenState createState() =>
      _LocalidadOcupacionPageScreenState();
}

class _LocalidadOcupacionPageScreenState
    extends State<LocalidadOcupacionPageScreen> {
  late String email;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null) {
      email = arguments as String;
    } else {
      // Redirigir al login si no hay email
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  //funcion back para actualizar datos del usuario por localidad y ocupacion
  Future<void> actualizarUsuarioLocalidadOcupacion(
      String localidad, String ocupacion) async {
    final url = Uri.parse("http://localhost:4000/updateLO");

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
          {"email": email, "localidad": localidad, "ocupacion": ocupacion}),
    );

    if (response.statusCode == 200) {
      print("Datos de localidad y ocupación actualizados correctamente");
    } else {
      print("Error al actualizar: ${response.body}");
    }
  }

  //variables
  String? selectedRegion;
  String? selectedOcupation;

  final List<String> regionOptions = ['Rural', 'Urbano', 'SubUrbano'];
  final List<String> ocupationOptions = [
    'Empleado',
    'Desempleado',
    'Estudiante',
    'Jubilado'
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sobre ti',
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
        backgroundColor: Color(0xFF2C3E50),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                "¿En qué tipo de región o localidad vives?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  value: selectedRegion,
                  isExpanded: true,
                  hint: Text("Tipo de localidad:"),
                  underline: SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRegion = newValue;
                    });
                  },
                  items: regionOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "¿Cuál es tu ocupación actual?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  value: selectedOcupation,
                  isExpanded: true,
                  hint: Text("Ocupación Actual:"),
                  underline: SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOcupation = newValue;
                    });
                  },
                  items: ocupationOptions.map((String value) {
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
                    // Validamos el formulario antes de continuar
                    if (_formKey.currentState?.validate() ?? false) {
                      // Si el formulario es válido, navegamos
                      actualizarUsuarioLocalidadOcupacion(
                          selectedRegion ?? "", selectedOcupation ?? "");
                      Navigator.pushNamed(context, '/saludHistorica',
                          arguments: email);
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
