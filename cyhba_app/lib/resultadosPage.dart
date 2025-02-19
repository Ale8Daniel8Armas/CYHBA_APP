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

  // Variable para almacenar la predicción del modelo
  String? predictionResult;

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
        fetchPrediction(); // Llamamos la función para obtener la predicción
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

  // Función para obtener la predicción desde el backend
  Future<void> fetchPrediction() async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:4000/predict"), // Ruta para la predicción
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Verificamos si la respuesta contiene una lista de predicciones
          if (data['prediction'] != null && data['prediction'].isNotEmpty) {
            var highestProbabilityPrediction = data['prediction'][0];
            double highestProbability =
                highestProbabilityPrediction['probability'];
            String disease = highestProbabilityPrediction['disease'];

            // Verificamos si hay otras predicciones con la misma probabilidad
            for (var prediction in data['prediction']) {
              if (prediction['probability'] > highestProbability) {
                highestProbability = prediction['probability'];
                disease = prediction['disease'];
              }
            }

            //int diseaseInt = int.parse(disease);

            // Asignamos la enfermedad con la mayor probabilidad
            if (disease == 'Alcohol use disorders') {
              disease = 'Arritmia';
            } else if (disease == 'Aortic aneurysm') {
              disease = 'Aneurisma aórtico';
            } else if (disease == 'Atrial fibrillation and flutter') {
              disease = 'Fibrilación y aleteo auricular';
            } else if (disease == 'Cardiomyopathy and myocarditis') {
              disease = 'Miocardiopatía y miocarditis';
            } else if (disease == 'Endocarditis') {
              disease = 'Endocarditis';
            } else if (disease == 'Hypertensive heart disease') {
              disease = 'Enfermedad cardíaca hipertensiva';
            } else if (disease == 'Ischemic heart disease') {
              disease = 'Cardiopatía isquémica';
            } else if (disease ==
                'Lower extremity peripheral arterial disease') {
              disease = 'Enfermedad arterial periférica';
            } else if (disease == 'Non-rheumatic valvular heart disease') {
              disease = 'Valvulopatía cardíaca no reumática';
            } else if (disease == 'Pulmonary Arterial Hypertension') {
              disease = 'Hipertensión arterial pulmonar';
            } else if (disease == 'Rheumatic heart disease') {
              disease = 'Enfermedad cardíaca reumática';
            } else {
              disease = 'Punzoneos no letales';
            }

            predictionResult =
                "$disease con ${highestProbability.toStringAsFixed(2)}% de probabilidad";
          } else {
            predictionResult = 'No se pudo obtener la predicción';
          }
        });
      } else {
        throw Exception("Error obteniendo la predicción");
      }
    } catch (e) {
      print("Error obteniendo la predicción: $e");
      setState(() {
        predictionResult = 'Error en la predicción';
      });
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

              SizedBox(height: 20),

              // Mostrar la predicción del modelo
              if (predictionResult != null)
                Text(
                  "Predicción de riesgo de enfermedad cardíaca: $predictionResult",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
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
