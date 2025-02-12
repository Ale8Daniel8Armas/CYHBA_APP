import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'vistasPerfil/edadGeneroPage.dart';
import "homePage.dart";
import 'dart:convert';
import 'config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isNotValidate = false;
  bool isLoading = false;
  String errorMessage = '';
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

// En loginPage.dart dentro del método loginUser()
  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
        // 1. Login inicial
        var regBody = {
          "email": emailController.text.trim(),
          "password": passwordController.text,
        };

        var response = await http.post(
          Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody),
        );

        var jsonResponse = jsonDecode(response.body);
        bool status = jsonResponse['status'] ?? false;

        if (status && jsonResponse['token'] != null) {
          var myToken = jsonResponse['token'];
          await prefs.setString('token', myToken);

          // 2. Verificar el estado del perfil
          var userResponse = await http.get(
            Uri.parse(
                'http://localhost:4000/getProfileComplete/${emailController.text.trim()}'),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $myToken"
            },
          );

          print("📥 Respuesta de perfil: ${userResponse.body}"); // Debug

          if (!mounted) return;

          var userJsonResponse = jsonDecode(userResponse.body);

          // Asegurarse de que isProfileComplete sea explícitamente convertido a bool
          bool isProfileComplete =
              userJsonResponse['isProfileComplete'] == true;

          print("🔍 isProfileComplete: $isProfileComplete"); // Debug

          if (!mounted) return;

          // 3. Redirigir basado en el estado del perfil
          if (!isProfileComplete) {
            print("🔄 Redirigiendo a EdadGeneroScreen"); // Debug
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EdadGeneroPageScreen(token: myToken),
              ),
            );
          } else {
            print("🔄 Redirigiendo a Home"); // Debug
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          }
        } else {
          if (mounted) {
            showError('Credenciales inválidas');
          }
        }
      } catch (e) {
        if (mounted) {
          showError('Error: ${e.toString()}');
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isNotValidate = true;
        });
      }
    }
  }

// Función auxiliar para mostrar errores
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back_Alternative.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/onlyheart.jpg'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'CYHBA App',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3E50),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Usuario/Correo:',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText: isNotValidate ? 'Campo requerido' : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: 'Contraseña:',
                          labelStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText: isNotValidate ? 'Campo requerido' : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ElevatedButton(
                  onPressed: isLoading ? null : loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '¿No tiene una cuenta?',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.pushNamed(context, '/registration'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Regístrese',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
