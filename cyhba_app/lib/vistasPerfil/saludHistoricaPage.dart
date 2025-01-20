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
        title: Text('Sobre ti'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Volver a la pantalla anterior
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ElevatedButton(
              onPressed: () {
                // Acción al presionar "Siguiente"
                if (selectedFamiliarEnfermo != null &&
                    selectedEnfermedadCardiaca != null &&
                    selectedDiabetes != null &&
                    selectedObesidad != null) {
                  // Continuar con el flujo
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Información guardada correctamente')),
                  );
                } else {
                  // Mostrar error si hay campos vacíos
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor completa todas las preguntas')),
                  );
                }
                Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Siguiente',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para las preguntas con Dropdown
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
