import 'package:flutter/material.dart';

class edadGeneroPageScreen extends StatefulWidget {
  @override
  _edadGeneroPageScreenState createState() => _edadGeneroPageScreenState();
}

class _edadGeneroPageScreenState extends State<edadGeneroPageScreen> {
  String? selectedAge;
  String? selectedGender;

  final List<String> ageOptions = [
    '18-25',
    '26-35',
    '36-45',
    '46-55',
    '56+',
  ];

  final List<String> genderOptions = ['Masculino', 'Femenino', 'Otro'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Sobre ti", style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Icon(Icons.health_and_safety, color: Colors.white),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Cuéntanos un poco de ti...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "¿Cuál es tu edad actual?",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.cyan[50],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                value: selectedAge,
                isExpanded: true,
                hint: Text("Edad:"),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAge = newValue;
                  });
                },
                items: ageOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "¿Cuál es tu género?",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.cyan[50],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                value: selectedGender,
                isExpanded: true,
                hint: Text("Género:"),
                underline: SizedBox(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGender = newValue;
                  });
                },
                items: genderOptions.map((String value) {
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
                  // Acción al presionar "Siguiente"
                  //print('Edad: $selectedAge, Género: $selectedGender');
                  Navigator.pushNamed(context, '/saludHistorica');
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
}
