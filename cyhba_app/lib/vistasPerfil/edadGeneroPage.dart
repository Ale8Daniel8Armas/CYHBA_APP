import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class EdadGeneroPageScreen extends StatefulWidget {
  final token;
  const EdadGeneroPageScreen({Key? key, required this.token}) : super(key: key);

  @override
  State<EdadGeneroPageScreen> createState() => _EdadGeneroPageScreenState();
}

class _EdadGeneroPageScreenState extends State<EdadGeneroPageScreen> {
  late String email;

  @override
  void initState() {
    super.initState();

    print("Token recibido: ${widget.token}"); // Depuración del token

    if (widget.token == null || JwtDecoder.isExpired(widget.token)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
        print("Token inválido o nulo");
      });
    } else {
      try {
        Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
        print("Token decodificado: $jwtDecodedToken"); // Depuración del token decodificado
        email = jwtDecodedToken['email'];
      } catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
          print("Error al decodificar el token: $e");
        });
      }
    }
  }



  String? selectedGender;
  final TextEditingController ageController = TextEditingController();

  final List<String> genderOptions = ['Masculino', 'Femenino', 'Otro'];

  final _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                "Cuéntanos un poco de ti...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 30),
              Text(
                "¿Cuál es tu edad actual?",
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
                child: TextFormField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Ingresa tu edad:",
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu edad';
                    }
                    int? age = int.tryParse(value);
                    if (age == null || age < 18 || age > 80) {
                      return 'Edad debe ser un número entre 18 y 80';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 30),
              Text(
                "¿Cuál es tu género?",
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
                    // Validamos el formulario antes de continuar
                    if (_formKey.currentState?.validate() ?? false) {
                      // Si el formulario es válido, navegamos
                      Navigator.pushNamed(context, '/localidadOcupacion');
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
