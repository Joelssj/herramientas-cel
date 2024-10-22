import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para construir la interfaz de usuario
import 'package:geolocator/geolocator.dart'; // Importa la biblioteca que permite acceder a la ubicación del dispositivo
import 'package:url_launcher/url_launcher.dart'; // Importa la biblioteca que permite abrir URLs en el navegador

// Clase principal para la pantalla de GPS, que es un widget con estado
class GpsScreen extends StatefulWidget {
  @override
  _GpsScreenState createState() => _GpsScreenState(); // Crea el estado de la pantalla
}

// Clase que maneja el estado de la pantalla de GPS
class _GpsScreenState extends State<GpsScreen> {
  String? _locationMessage = ''; // Variable para almacenar el mensaje de ubicación
  bool _isLoading = false; // Variable para saber si se está cargando la ubicación

  // Método para obtener la ubicación actual
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true; // Cambia el estado a "cargando" cuando se inicia la solicitud
    });

    try {
      // Solicita permisos para acceder a la ubicación
      bool serviceEnabled; // Variable para verificar si los servicios de ubicación están habilitados
      LocationPermission permission; // Variable para verificar los permisos de ubicación

      // Verifica si los servicios de ubicación están habilitados
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) { // Si los servicios no están habilitados
        setState(() {
          _locationMessage = 'Los servicios de ubicación están desactivados.'; // Muestra un mensaje de error
          _isLoading = false; // Cambia el estado de carga
        });
        return; // Sal del método
      }

      // Solicita permisos de ubicación
      permission = await Geolocator.checkPermission(); // Verifica el estado de los permisos
      if (permission == LocationPermission.denied) { // Si los permisos son denegados
        permission = await Geolocator.requestPermission(); // Solicita los permisos
        if (permission == LocationPermission.denied) { // Si aún son denegados
          setState(() {
            _locationMessage = 'Los permisos de ubicación han sido denegados'; // Muestra un mensaje de error
            _isLoading = false; // Cambia el estado de carga
          });
          return; // Sal del método
        }
      }

      // Manejo de permisos denegados permanentemente
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationMessage = 'Los permisos de ubicación han sido denegados permanentemente'; // Mensaje de error
          _isLoading = false; // Cambia el estado de carga
        });
        return; // Sal del método
      }

      // Obtiene la ubicación actual con precisión media
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10)); // Límite de tiempo de 10 segundos para obtener la ubicación

      // Actualiza el estado con la ubicación obtenida
      setState(() {
        _locationMessage = "Latitud: ${position.latitude}, Longitud: ${position.longitude}"; // Muestra la ubicación
        _isLoading = false; // Cambia el estado de carga
      });

      // Genera un enlace para Google Maps con la ubicación
      final googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
      _openLink(googleMapsUrl); // Llama a la función para abrir el enlace

    } catch (e) { // Manejo de errores
      setState(() {
        _locationMessage = 'Error obteniendo la ubicación: $e'; // Muestra un mensaje de error si algo sale mal
        _isLoading = false; // Cambia el estado de carga
      });
    }
  }

  // Función para abrir una URL en el navegador
  void _openLink(String url) async {
    final uri = Uri.parse(url); // Convierte la cadena de texto de la URL en un objeto Uri
    try {
      // Intenta abrir la URL en el navegador
      if (!await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Abre la URL en una nueva aplicación
      )) {
        throw 'No se pudo abrir el enlace $url'; // Mensaje de error si no se puede abrir
      }
    } catch (e) {
      print('No se pudo abrir el enlace: $e'); // Imprime un mensaje de error en la consola
    }
  }

  // Método para construir la interfaz de usuario de la pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicación GPS'), // Título de la AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading
                ? CircularProgressIndicator() // Muestra un indicador de carga mientras se obtiene la ubicación
                : Text(
                    _locationMessage ?? '', // Muestra el mensaje de ubicación
                    textAlign: TextAlign.center, // Centra el texto
                  ),
            SizedBox(height: 20), // Espaciado vertical
            ElevatedButton(
              onPressed: _getCurrentLocation, // Llama a la función para obtener la ubicación al presionar el botón
              child: Text('Obtener Ubicación Actual'), // Texto del botón
            ),
          ],
        ),
      ),
    );
  }
}
