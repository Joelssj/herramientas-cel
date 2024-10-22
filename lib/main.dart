import 'package:flutter/material.dart'; 
import 'package:url_launcher/url_launcher.dart';
import 'screens/qr_screen.dart'; 
import 'screens/geolocator_screen.dart'; 
import 'screens/microfono_screen.dart'; 
import 'screens/sensor_screen.dart'; 

void main() {
  runApp(const MyApp()); 
}


class MyApp extends StatelessWidget {
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', 
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, 
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo[900], 
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold), 
        ),
      ),
      home: const MyHomePage(), // La pantalla inicial de la app
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key}); 

  @override
  _MyHomePageState createState() => _MyHomePageState(); 
}

class _MyHomePageState extends State<MyHomePage> {
  void _openLink() async {
    final githubUri = Uri.parse('https://github.com/Joelssj/herramientas-cel.git'); 
    try {
      if (!await launchUrl(
        githubUri,
        mode: LaunchMode.externalApplication, 
      )) {
        throw 'No se pudo abrir el enlace $githubUri'; 
      }
    } catch (e) {
      print('No se pudo abrir el enlace: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Estudiante'), 
        centerTitle: true, // Centra el título
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                // Fila con los íconos en la parte superior
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.location_on, color: Colors.indigo),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => GpsScreen()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.qr_code, color: Colors.indigo),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const QrScreen()), 
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.sensors, color: Colors.indigo),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SensoresScreen()), 
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic, color: Colors.indigo),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => MicroScreen()), 
                        );
                      },
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundImage: const AssetImage('assets/Logo.jpg'), 
                  radius: 40, 
                ),
              ],
            ),
            const Spacer(), 
            Center(
              child: Column(
                children: const <Widget>[
                  Text(
                    'Joel de Jesus Lopez Ruiz', 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black), // Estilo del texto
                  ),
                  SizedBox(height: 8), 
                  Text(
                    '221204', 
                    style: TextStyle(fontSize: 18, color: Colors.black54), // Estilo de la matrícula
                  ),
                  SizedBox(height: 8), 
                  Text(
                    'Grupo: 9A',
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  SizedBox(height: 8), 
                  Text(
                    'Ingeniería en Software', 
                    style: TextStyle(fontSize: 18, color: Colors.black87), 
                  ),
                  SizedBox(height: 8), 
                  Text(
                    'Aplicaciones Móviles', 
                    style: TextStyle(fontSize: 18, color: Colors.black87), 
                  ),
                ],
              ),
            ),
            const Spacer(), 
            ElevatedButton(
              onPressed: _openLink, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[800], 
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), 
                minimumSize: const Size.fromHeight(50), 
              ),
              child: const Text('Abrir GitHub', style: TextStyle(color: Colors.white, fontSize: 16)), 
            ),
          ],
        ),
      ),
    );
  }
}
