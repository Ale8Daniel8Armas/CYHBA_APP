import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String email;
  bool _initialized = false;
  String userName = "Cargando..."; // Variable inicializada correctamente

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments != null && arguments is String) {
        setState(() {
          email = arguments;
          _initialized = true;
          _fetchUserName(email); // Llamar a la función para obtener el nombre
        });
      } else {
        // Redirigir al login si no hay email
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  // Función para obtener el nombre de usuario
  Future<void> _fetchUserName(String email) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:4000/getName/$email'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['nombre'] ?? "Sin Nombre";
        });
      } else {
        setState(() {
          userName = "Usuario no encontrado";
        });
      }
    } catch (e) {
      print("Error al obtener el nombre: $e");
      setState(() {
        userName = "Error al cargar";
      });
    }
  }

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize:
              MainAxisSize.min, // Ajusta el tamaño del Row al contenido
          children: [
            Text(
              'CYHBA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10), // Espaciado entre el título y el avatar
            CircleAvatar(
              radius: 16, // Tamaño del avatar
              backgroundImage: AssetImage('assets/onlyheart.jpg'),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            //Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFF2C3E50),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar con imagen seleccionada o predeterminada
              GestureDetector(
                onTap: _pickImage, // Al tocar la imagen, se selecciona otra
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: _image != null
                          ? FileImage(_image!) // Muestra la imagen seleccionada
                          : null,
                      backgroundColor: Colors.transparent,
                      child: _image == null
                          ? Icon(Icons.person,
                              size: 100, color: Colors.grey) // Icono de persona
                          : null,
                    ),
                    if (_image ==
                        null) // Si no hay imagen, agregar icono de cámara
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Nombre con estilo
              Text(
                'Bienvenido $userName',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              // Botón estilizado
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/estadoSaludUno',
                      arguments: email);
                },
                child: Text("Iniciar Diagnóstico"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent, // Color de fondo
                  foregroundColor: Colors.white, // Color del texto
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Texto informativo con estilo
              Text(
                "Frecuencia consumo: Moderado",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Salud',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Manejar la navegación entre botones
        },
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black54,
      ),
    );
  }
}
