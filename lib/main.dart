import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => MotoProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'App Motos', home: const Pantalla1());
  }
}

class Moto {
  final String marcaModelo;
  final double fuelTankLiters;
  final double consumptionL100;

  Moto({
    required this.marcaModelo,
    required this.fuelTankLiters,
    required this.consumptionL100,
  });
}

class MotoProvider extends ChangeNotifier {
  final List<Moto> motos = [
    Moto(
      marcaModelo: 'Honda PCX 125',
      fuelTankLiters: 8.0,
      consumptionL100: 2.1,
    ),
    Moto(
      marcaModelo: 'Yamaha NMAX 125',
      fuelTankLiters: 7.1,
      consumptionL100: 2.2,
    ),
    Moto(
      marcaModelo: 'Kymco Agility City 125',
      fuelTankLiters: 7.0,
      consumptionL100: 2.5,
    ),
    Moto(
      marcaModelo: 'Piaggio Liberty 125',
      fuelTankLiters: 6.0,
      consumptionL100: 2.3,
    ),
    Moto(
      marcaModelo: 'Sym Symphony 125',
      fuelTankLiters: 5.5,
      consumptionL100: 2.4,
    ),
    Moto(
      marcaModelo: 'Vespa Primavera 125',
      fuelTankLiters: 8.0,
      consumptionL100: 2.8,
    ),
    Moto(
      marcaModelo: 'Kawasaki J125',
      fuelTankLiters: 11.0,
      consumptionL100: 3.5,
    ),
    Moto(
      marcaModelo: 'Peugeot Pulsion 125',
      fuelTankLiters: 12.0,
      consumptionL100: 3.0,
    ),
  ];

  Moto? motoSeleccionada;
  double kmInicio = 0;
  double kmActual = 0;

  void seleccionarMoto(Moto moto) {
    motoSeleccionada = moto;
    notifyListeners();
  }

  void setKmInicio(double valor) {
    kmInicio = valor;
    notifyListeners();
  }

  void setKmActual(double valor) {
    kmActual = valor;
    notifyListeners();
  }

  double calcularKmRestantes() {
    if (motoSeleccionada == null) return 0;

    if (kmActual < kmInicio) return 0;

    double consumidos =
        (kmActual - kmInicio) * motoSeleccionada!.consumptionL100 / 100;
    double combustibleRestante = motoSeleccionada!.fuelTankLiters - consumidos;
    double kmPosibles =
        (combustibleRestante / motoSeleccionada!.consumptionL100) * 100;
    return kmPosibles < 0 ? 0 : kmPosibles;
  }
}

// Primera pantalla: elegir la moto
class Pantalla1 extends StatefulWidget {
  const Pantalla1({super.key});

  @override
  State<Pantalla1> createState() => _Pantalla1State();
}

class _Pantalla1State extends State<Pantalla1> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MotoProvider>(context);

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(title: const Text('Selecciona una moto')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<Moto>(
              value: provider.motoSeleccionada,
              hint: const Text('Elige un modelo'),
              items: provider.motos.map((moto) {
                return DropdownMenuItem(
                  value: moto,
                  child: Text(moto.marcaModelo),
                );
              }).toList(),
              onChanged: (valor) {
                if (valor != null) provider.seleccionarMoto(valor);
              },
            ),
            const SizedBox(height: 20),
            if (provider.motoSeleccionada != null)
              Text(
                'Moto seleccionada: ${provider.motoSeleccionada!.marcaModelo}',
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: provider.motoSeleccionada == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Pantalla2(),
                        ),
                      );
                    },
              child: const Text('Calcular'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 16),
                backgroundColor: const Color.fromARGB(255, 49, 93, 129),
                foregroundColor: Colors.white,
                elevation: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Segunda pantalla: mostrar datos y calcular km restantes automáticamente
class Pantalla2 extends StatefulWidget {
  const Pantalla2({super.key});

  @override
  State<Pantalla2> createState() => _Pantalla2State();
}

class _Pantalla2State extends State<Pantalla2> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MotoProvider>(context);
    final moto = provider.motoSeleccionada!;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(title: const Text('Datos de la moto')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Modelo: ${moto.marcaModelo}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Depósito: ${moto.fuelTankLiters} L',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Consumo: ${moto.consumptionL100} L/100km',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Km al llenar depósito',
                ),
                keyboardType: TextInputType.number,
                onChanged: (v) => provider.setKmInicio(double.tryParse(v) ?? 0),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              child: TextField(
                decoration: const InputDecoration(labelText: 'Km actuales'),
                keyboardType: TextInputType.number,
                onChanged: (v) => provider.setKmActual(double.tryParse(v) ?? 0),
              ),
            ),
            const SizedBox(height: 30),
            if (provider.kmInicio > 0 &&
                provider.kmActual > 0 &&
                provider.kmActual >= provider.kmInicio)
              Text(
                'Autonomía restante: ${provider.calcularKmRestantes().toStringAsFixed(1)} km',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
