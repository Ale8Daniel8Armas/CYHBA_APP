import 'package:flutter/material.dart';

class saludHistoricaPageScreen extends StatefulWidget {
  @override
  _saludHistoricaPageScreenState createState() => _saludHistoricaPageScreenState();
}

class _saludHistoricaPageScreenState extends State<saludHistoricaPageScreen> {
  // Variables para almacenar las selecciones del usuario
  String? selectedFamiliarEnfermo;
  String? selectedEnfermedadCardiaca;
  String? selectedDiabetes;
  String? selectedObesidad;

  // Opciones para los menús desplegables
  final List<String> opciones = ['Sí', 'No'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre ti',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            preguntaDropdown(
              context,
              '¿Algún familiar tuyo tiene una enfermedad?',
              'Familiar enfermo:',
              selectedFamiliarEnfermo,
                  (newValue) {
                setState(() {
                  selectedFamiliarEnfermo = newValue;
                });
              },
            ),
            preguntaDropdown(
              context,
              '¿Has padecido o padeces de una enfermedad al corazón?',
              'Enfermedad cardíaca:',
              selectedEnfermedadCardiaca,
                  (newValue) {
                setState(() {
                  selectedEnfermedadCardiaca = newValue;
                });
              },
            ),
            preguntaDropdown(
              context,
              '¿Tienes diabetes?',
              'Diabetes:',
              selectedDiabetes,
                  (newValue) {
                setState(() {
                  selectedDiabetes = newValue;
                });
              },
            ),
            preguntaDropdown(
              context,
              '¿Tienes obesidad?',
              'Obesidad:',
              selectedObesidad,
                  (newValue) {
                setState(() {
                  selectedObesidad = newValue;
                });
              },
            ),
            Spacer(),
            Center(
            child: ElevatedButton(
              onPressed: () {
                if (selectedFamiliarEnfermo != null &&
                    selectedEnfermedadCardiaca != null &&
                    selectedDiabetes != null &&
                    selectedObesidad != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Información guardada correctamente')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor completa todas las preguntas')),
                  );
                }
                Navigator.pushNamed(context, '/home');
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
    );
  }

  Widget preguntaDropdown(
      BuildContext context,
      String pregunta,
      String label,
      String? selectedValue,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pregunta,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(label),
              isExpanded: true,
              underline: SizedBox(),
              items: opciones
                  .map(
                    (opcion) => DropdownMenuItem<String>(
                  value: opcion,
                  child: Text(opcion),
                ),
              )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
