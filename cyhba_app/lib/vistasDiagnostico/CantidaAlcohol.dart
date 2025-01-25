import 'package:flutter/material.dart';

class CantidadConsumoScreen extends StatefulWidget {
  @override
  _CantidadConsumoScreenState createState() => _CantidadConsumoScreenState();
}

class _CantidadConsumoScreenState extends State<CantidadConsumoScreen> {
  List<String> selectedBeers = [];
  int numberOfBeers = 0;
  List<String> selectedVines = [];
  int numberOfVines = 0;
  List<String> selectedVodkas = [];
  int numberOfVodkas = 0;
  List<String> selectedChampams = [];
  int numberOfChampans = 0;
  List<String> selectedBrandys = [];
  int numberOfBrandys = 0;
  bool canProceed1 = false;
  bool canProceed2 = false;
  bool canProceed3 = false;
  bool canProceed4 = false;
  bool canProceed5 = false;

  void toggleBeerSelection(String beer) {
    setState(() {
      if (selectedBeers.contains(beer)) {
        selectedBeers.remove(beer);
      } else {
        selectedBeers.add(beer);
      }
      if(selectedBeers.length == 0){
        print('Por favor seleccione una cerveza (0 ml si no toma)');
      } else{
        canProceed1 = selectedBeers.length > 0;
      }
    });
  }

  void toggleVineSelection(String vine){
    setState(() {
      if (selectedVines.contains(vine)) {
        selectedVines.remove(vine);
      } else {
        selectedVines.add(vine);
      }
      if(selectedVines.length == 0){
        print('Por favor seleccione un vino (0 ml si no toma)');
      } else{
        canProceed2 = selectedVines.length > 0;
      }
    });
  }

  void toggleVodkaSelection(String vodka){
    setState(() {
      if (selectedVodkas.contains(vodka)) {
        selectedVodkas.remove(vodka);
      } else {
        selectedVodkas.add(vodka);
      }
      if(selectedVodkas.length == 0){
        print('Por favor seleccione un vodka (0 ml si no toma)');
      } else{
        canProceed3 = selectedVodkas.length > 0;
      }
    });
  }

  void toggleChampanSelection(String champan){
    setState(() {
      if (selectedChampams.contains(champan)) {
        selectedChampams.remove(champan);
      } else {
        selectedChampams.add(champan);
      }
      if(selectedChampams.length == 0){
        print('Por favor seleccione una bebida o vino espumoso(0 ml si no toma)');
      } else{
        canProceed4 = selectedChampams.length > 0;
      }
    });
  }

  void toggleBrandySelection(String brandy) {
    setState(() {
      if (selectedBrandys.contains(brandy)) {
        selectedBrandys.remove(brandy);
      } else {
        selectedBrandys.add(brandy);
      }
      if(selectedBrandys.length == 0){
        print('Por favor seleccione un brandy o aguardiente (0 ml si no toma)');
      } else{
        canProceed5 = selectedBrandys.length > 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cantidad de consumo',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seleccione las bebidas que ha bebido hasta ahora con su respectivo volumen de consumo:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/cantidadConsumo.jpg',
                  width: 300,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              Text('Cerveza', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  '0 ml',
                  '50 ml',
                  '150 ml',
                  '300 ml',
                  '350 ml',
                  '400 ml',
                  '450 ml',
                  '500 ml',
                  '700 ml',
                  '750 ml',
                  '1000 ml'
                ].map((volume) {
                  return ChoiceChip(
                    label: Text('Cerveza $volume'),
                    selected: selectedBeers.contains(volume),
                    onSelected: (isSelected) => toggleBeerSelection(volume),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Número de cervezas al día: $numberOfBeers'),
                  Expanded(
                    child: Slider(
                      value: numberOfBeers.toDouble(),
                      min: 0,
                      max: 20,
                      divisions: 20,
                      label: numberOfBeers.toString(),
                      onChanged: (value) {
                        setState(() {
                          numberOfBeers = value.toInt();
                          //canProceed = numberOfBeers > 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                '¡Deslice hacia abajo para agregar más bebidas como vinos o licores! 🍷🥃',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text('Vino', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  '0 ml',
                  '50 ml',
                  '150 ml',
                  '300 ml',
                  '375 ml',
                  '500 ml',
                  '750 ml',
                  '1000 ml',
                  '1500 ml',
                ].map((volume) {
                  return ChoiceChip(
                    label: Text('Vino $volume'),
                    selected: selectedVines.contains(volume),
                    onSelected: (isSelected) => toggleVineSelection(volume),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Número de vinos al día: $numberOfVines'),
                  Expanded(
                    child: Slider(
                      value: numberOfVines.toDouble(),
                      min: 0,
                      max: 20,
                      divisions: 20,
                      label: numberOfVines.toString(),
                      onChanged: (value) {
                        setState(() {
                          numberOfVines = value.toInt();
                          //canProceed = numberOfVines > 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Vodkas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  '0 ml',
                  '50 ml',
                  '150 ml',
                  '300 ml',
                  '375 ml',
                  '500 ml',
                  '750 ml',
                  '1000 ml',
                  '1500 ml',
                ].map((volume) {
                  return ChoiceChip(
                    label: Text('Vodka $volume'),
                    selected: selectedVodkas.contains(volume),
                    onSelected: (isSelected) => toggleVodkaSelection(volume),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Número de vodkas al día: $numberOfVodkas'),
                  Expanded(
                    child: Slider(
                      value: numberOfVodkas.toDouble(),
                      min: 0,
                      max: 20,
                      divisions: 20,
                      label: numberOfVodkas.toString(),
                      onChanged: (value) {
                        setState(() {
                          numberOfVodkas = value.toInt();
                          //canProceed = numberOfVodkas > 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Bebidas espumosas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  '0 ml',
                  '50 ml',
                  '150 ml',
                  '300 ml',
                  '375 ml',
                  '500 ml',
                  '750 ml',
                  '1000 ml',
                  '1500 ml',
                ].map((volume) {
                  return ChoiceChip(
                    label: Text('Bebida espumosa $volume'),
                    selected: selectedChampams.contains(volume),
                    onSelected: (isSelected) => toggleChampanSelection(volume),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Número de bebidas espumosas al día: $numberOfChampans'),
                  Expanded(
                    child: Slider(
                      value: numberOfChampans.toDouble(),
                      min: 0,
                      max: 20,
                      divisions: 20,
                      label: numberOfChampans.toString(),
                      onChanged: (value) {
                        setState(() {
                          numberOfChampans = value.toInt();
                          //canProceed = numberOfChampans > 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Brandys/Aguardientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  '0 ml',
                  '50 ml',
                  '159 ml',
                  '300 ml',
                  '375 ml',
                  '500 ml',
                  '750 ml',
                  '1000 ml',
                  '1500 ml',
                ].map((volume) {
                  return ChoiceChip(
                    label: Text('Brandy/Aguardiente $volume'),
                    selected: selectedBrandys.contains(volume),
                    onSelected: (isSelected) => toggleBrandySelection(volume),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Número de aguardientes al día: $numberOfBrandys'),
                  Expanded(
                    child: Slider(
                      value: numberOfBrandys.toDouble(),
                      min: 0,
                      max: 20,
                      divisions: 20,
                      label: numberOfBrandys.toString(),
                      onChanged: (value) {
                        setState(() {
                          numberOfBrandys = value.toInt();
                          //canProceed = numberOfBrandys > 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (canProceed1 && canProceed2 && canProceed3 && canProceed4 && canProceed5) {
                    Navigator.pushNamed(context, '/frecuencia');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Por favor selecciona un ítem de cada opción (0 ml si no toma)."),
                      ),
                    );
                  }
                },
                child: const Text('Siguiente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
