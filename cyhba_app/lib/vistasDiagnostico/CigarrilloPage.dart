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

  //funcion back para actualizar datos en el cigarrillo
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

  //llamada de los getters de calculo
  Future<double> fetchUnidadesAlcohol(String email) async {
    final url = Uri.parse("http://localhost:4000/getUnidadesAlcohol/$email");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['unidadesAlcohol'];
    } else {
      throw Exception("Error obteniendo unidades de alcohol");
    }
  }

  Future<int> fetchConsumoPorDias(String email) async {
    final url = Uri.parse("http://localhost:4000/getConsumo/$email");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['consumoPorDias'];
    } else {
      throw Exception("Error obteniendo consumo por días");
    }
  }

  Future<int> fetchFrecuenciaSemanal(String email) async {
    final url = Uri.parse("http://localhost:4000/getFrecuencia/$email");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['frecuenciaSemanal'];
    } else {
      throw Exception("Error obteniendo frecuencia semanal");
    }
  }

//funcion de calculo de la frecuencia de consumo del alcohol
  Future<void> calcularSTU(String email) async {
    try {
      double unidadesAlcohol = await fetchUnidadesAlcohol(email);
      int consumoPorDias = await fetchConsumoPorDias(email);
      int frecuenciaSemanal = await fetchFrecuenciaSemanal(email);

      final url = Uri.parse("http://localhost:4000/calcularConsumo");

      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "unidadesAlcohol": unidadesAlcohol,
          "consumoPorDias": consumoPorDias,
          "frecuenciaSemanal": frecuenciaSemanal,
        }),
      );

      if (response.statusCode == 200) {
        print("STU actualizado correctamente");
      } else {
        print("Error al actualizar STU: ${response.body}");
      }
    } catch (error) {
      print("Error en la solicitud: $error");
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
                    calcularSTU(email);
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
