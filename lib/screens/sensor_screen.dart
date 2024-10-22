import 'package:flutter/material.dart'; 
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';

class SensoresScreen extends StatefulWidget {
  @override
  _SensoresScreenState createState() => _SensoresScreenState(); 
}

class _SensoresScreenState extends State<SensoresScreen> {
  String _accelerometer = "Acelerómetro: esperando datos..."; 
  String _gyroscope = "Giroscopio: esperando datos..."; 
  String _magnetometer = "Magnetómetro: esperando datos..."; 

  final double _threshold = 0.2; 
  final int _staticDuration = 200; 
  bool _isStatic = false; 
  DateTime _lastUpdate = DateTime.now(); 

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;

  @override
  void initState() {
    super.initState(); 

    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        if (DateTime.now().difference(_lastUpdate).inMilliseconds >= _staticDuration) {
          _isStatic = event.x.abs() < _threshold && 
                      event.y.abs() < _threshold &&
                      (event.z - 9.81).abs() < _threshold;

          if (_isStatic) {
            _lastUpdate = DateTime.now(); 
          }
        }

        _accelerometer = _isStatic 
            ? 'Acelerómetro: Estático' 
            : 'Acelerómetro: \nX: ${event.x}, Y: ${event.y}, Z: ${event.z}';
      });
    });

    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscope = 'Giroscopio: \nX: ${event.x}, Y: ${event.y}, Z: ${event.z}';
      });
    }, onError: (error) {
      setState(() {
        _gyroscope = 'Giroscopio: Sensor no encontrado'; 
      });
    });

    _magnetometerSubscription = magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        _magnetometer = 'Magnetómetro: \nX: ${event.x}, Y: ${event.y}, Z: ${event.z}';
      });
    }, onError: (error) {
      setState(() {
        _magnetometer = 'Magnetómetro: Sensor no encontrado'; 
      });
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _magnetometerSubscription?.cancel();
    super.dispose(); // Llamamos al dispose de la clase padre
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sensores del dispositivo',
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: Color.fromARGB(255, 24, 24, 24), // Fondo oscuro
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      body: Container(
        color: Color.fromARGB(255, 0, 0, 0), 
        padding: const EdgeInsets.all(16.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Text(
              _accelerometer, 
              style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 255, 255)) 
            ),
            SizedBox(height: 20), 
            Text(
              _gyroscope, 
              style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 255, 255)) 
            ),
            SizedBox(height: 20), 
            Text(
              _magnetometer, 
              style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 255, 255)) 
            ),
          ],
        ),
      ),
    );
  }
}
