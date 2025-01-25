import 'package:flutter/material.dart';

class BeverageSelectionPage extends StatefulWidget {
  @override
  _BeverageSelectionPageState createState() => _BeverageSelectionPageState();
}


class _BeverageSelectionPageState extends State<BeverageSelectionPage> {
  String? selectedBeverage;

  final beverages = [
    {"name": "Vino", "image": "assets/vino.jpg"},
    {"name": "Cerveza", "image": "assets/cerveza.jpg"},
    {"name": "Vodka", "image": "assets/vodka.jpg"},
    {"name": "Vino espumoso", "image": "assets/champagne.jpg"},
    {"name": "Aguardiente", "image": "assets/brandy.png"},
    {"name": "Agua (no tomo)", "image": "assets/agua.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bebidas de consumo',
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
        child: Column(
          children: [
            const Text(
              "Escoja la bebida alcohólica que ha consumido con mayor frecuencia o la de su preferencia (solo uno)",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.1,
                ),
                itemCount: beverages.length,
                itemBuilder: (context, index) {
                  final beverage = beverages[index];
                  final isSelected = selectedBeverage == beverage["name"];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBeverage = beverage["name"];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.red : Colors.black,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                beverage["image"]!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.black,
                            child: Text(
                              beverage["name"]!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedBeverage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Seleccionaste: $selectedBeverage")),
                  );
                  Navigator.pushNamed(context, '/cantidadAlcohol');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Por favor selecciona una bebida")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text(
                "Siguiente",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
