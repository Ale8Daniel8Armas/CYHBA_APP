import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResultadosScreen extends StatefulWidget {
  @override
  _ResultadosScreenState createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  late String email;
  bool _initialized = false;

  // Variables para almacenar los resultados
  String? consumoAlcohol;
  double unidadesAlco = 0;
  int consumoDias = 0;
  int frecuenciaNumeroDiasALaSemana = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null && arguments is String) {
        setState(() {
          email = arguments;
          _initialized = true;
        });
        // Llamar a las funciones para obtener los datos
        fetchData();
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  // Función para obtener todos los datos
  Future<void> fetchData() async {
    try {
      final unidades = await fetchUnidadesAlcohol(email);
      final consumo = await fetchConsumoPorDias(email);
      final frecuencia = await fetchFrecuenciaSemanal(email);
      final alcohol = await fetchConsumoAlcohol(email);

      setState(() {
        unidadesAlco = unidades;
        consumoDias = consumo;
        frecuenciaNumeroDiasALaSemana = frecuencia;
        consumoAlcohol = alcohol;
      });
    } catch (e) {
      print("Error obteniendo datos: $e");
    }
  }

  // Funciones para obtener los datos desde el backend
  Future<double> fetchUnidadesAlcohol(String email) async {
    final url = Uri.parse("http://localhost:4000/getUnidadesAlcohol/$email");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['unidadesAlcohol'].toDouble();
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

  Future<String> fetchConsumoAlcohol(String email) async {
    final url = Uri.parse("http://localhost:4000/getConsumoAlcohol/$email");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['consumoAlcohol'];
    } else {
      throw Exception("Error obteniendo el tipo de consumo de alcohol");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resultado',
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
        backgroundColor: Color(0xFF008000),
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
                "Basado en el análisis de sus respuestas y condiciones que usted posee, aludiendo a un nivel de consumo de alcohol bajo, elevado o moderado, usted podría sufrir de la siguiente enfermedad cardíaca si sigue el ritmo en el que está actualmente:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Mostrar resultados obtenidos
              Text(
                "Consumo de alcohol: ${consumoAlcohol ?? 'Cargando...'}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Unidades de alcohol consumidas: ${unidadesAlco.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Consumo por días: $consumoDias días",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Frecuencia semanal: $frecuenciaNumeroDiasALaSemana días",
                style: TextStyle(fontSize: 16),
              ),

              Spacer(),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Text("Finalizar"),
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
