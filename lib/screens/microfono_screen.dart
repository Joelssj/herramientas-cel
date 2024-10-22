import 'package:flutter/material.dart'; // Importa la biblioteca de Flutter para construir la interfaz de usuario
import 'package:permission_handler/permission_handler.dart'; // Importa la biblioteca para manejar permisos
import 'package:speech_to_text/speech_to_text.dart' as stt; // Importa la biblioteca para el reconocimiento de voz
import 'package:flutter_tts/flutter_tts.dart'; // Importa la biblioteca para convertir texto a voz

// Clase principal para la pantalla de grabación y reproducción de texto, que es un widget con estado
class MicroScreen extends StatefulWidget {
  @override
  _MicroScreenState createState() => _MicroScreenState(); // Crea el estado de la pantalla
}

// Clase que maneja el estado de la pantalla de grabación y reproducción de texto
class _MicroScreenState extends State<MicroScreen> {
  late stt.SpeechToText _speech; // Variable para el reconocimiento de voz
  late FlutterTts _flutterTts; // Variable para el texto a voz
  bool _isListening = false; // Variable para saber si está escuchando
  String _speechText = ''; // Variable para almacenar el texto reconocido
  String _selectedLanguage = "en-US"; // Idioma seleccionado, por defecto inglés

  // Método que se llama al iniciar el widget
  @override
  void initState() {
    super.initState(); // Llama al método initState de la clase padre
    _initializeSpeech(); // Inicializa el reconocimiento de voz
    _initializeTts(); // Inicializa el texto a voz
  }

  // Método para inicializar el reconocimiento de voz
  Future<void> _initializeSpeech() async {
    _speech = stt.SpeechToText(); // Crea una instancia de SpeechToText
    await _requestMicrophonePermission(); // Solicita permiso para acceder al micrófono
  }

  // Método para inicializar el texto a voz
  Future<void> _initializeTts() async {
    _flutterTts = FlutterTts(); // Crea una instancia de FlutterTts
    await _flutterTts.setLanguage(_selectedLanguage); // Establece el idioma para TTS
  }

  // Método para solicitar permiso de micrófono
  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status; // Verifica el estado del permiso
    if (!status.isGranted) { // Si el permiso no está concedido
      await Permission.microphone.request(); // Solicita el permiso
    }
  }

  // Método para comenzar a escuchar el micrófono
  Future<void> _startListening() async {
    var status = await Permission.microphone.request(); // Solicita el permiso del micrófono
    if (status.isGranted) { // Si el permiso es concedido
      bool available = await _speech.initialize( // Inicializa el reconocimiento de voz
        onStatus: (val) { // Callback para manejar el estado
          if (val == 'done') { // Si el reconocimiento de voz ha terminado
            _stopListening(); // Detiene la escucha
          }
        },
        onError: (val) => print('Error: $val'), // Manejo de errores
      );

      if (available) {
        setState(() => _isListening = true); // Cambia el estado a "escuchando"
        _speech.listen( // Comienza a escuchar
          onResult: (val) { // Callback para manejar el resultado del reconocimiento
            if (mounted) { // Verifica si el widget está montado
              setState(() {
                _speechText = val.recognizedWords; // Almacena el texto reconocido
              });
            }
          },
          localeId: _selectedLanguage, // Establece el idioma
        );
      }
    } else {
      print("Permisos de micrófono denegados"); // Mensaje si el permiso es denegado
    }
  }

  // Método para detener la escucha del micrófono
  void _stopListening() {
    if (_isListening) { // Si está escuchando
      _speech.stop(); // Detiene la escucha
      if (mounted) {
        setState(() => _isListening = false); // Cambia el estado a "no escuchando"
      }
    }
  }

  // Método para cambiar el idioma del texto a voz
  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode; // Cambia el idioma seleccionado
    });
    _flutterTts.setLanguage(languageCode); // Establece el idioma para TTS
  }

  // Método para convertir el texto a voz
  Future<void> _speak() async {
    if (_speechText.isNotEmpty) { // Si hay texto para reproducir
      await _flutterTts.speak(_speechText); // Reproduce el texto
    } else {
      await _flutterTts.speak('No hay texto para reproducir.'); // Mensaje si no hay texto
    }
  }

  // Método que se llama al destruir el widget
  @override
  void dispose() {
    _stopListening(); // Asegúrate de detener el reconocimiento de voz
    _speech.cancel(); // Cancela la escucha
    super.dispose(); // Llama al método dispose de la clase padre
  }

  // Método para construir la interfaz de usuario de la pantalla
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grabar y Reproducir Texto', // Título de la AppBar
          style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)), // Título en amarillo
        ),
        backgroundColor: Color.fromARGB(255, 24, 24, 24), // Fondo oscuro
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)), // Color de la flecha en amarillo
      ),
      body: Container(
        color: Color.fromARGB(255, 0, 0, 0), // Fondo negro
        padding: const EdgeInsets.all(16.0), // Espaciado en el contenedor
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0), // Espaciado en el contenedor
                child: Container(
                  padding: EdgeInsets.all(12), // Espaciado interno
                  decoration: BoxDecoration(
                    color: Colors.grey[800], // Fondo del contenedor
                    borderRadius: BorderRadius.circular(12), // Bordes redondeados
                    border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)), // Borde en cian
                  ),
                  child: Text(
                    _speechText.isEmpty
                        ? 'Presiona el micrófono para empezar a grabar...' // Mensaje predeterminado
                        : _speechText, // Muestra el texto reconocido
                    style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 255, 255)), // Texto en cian
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0), // Espaciado
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distribuye los íconos en la fila
                children: [
                  IconButton(
                    icon: Icon(
                      _isListening ? Icons.mic_off : Icons.mic, // Cambia el ícono según si está escuchando
                      color: const Color.fromARGB(255, 255, 255, 255), // Color del ícono en cian
                      size: 36.0, // Tamaño del ícono
                    ),
                    onPressed: _isListening ? _stopListening : _startListening, // Cambia entre escuchar y detener
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.volume_up, // Ícono de volumen
                      color: const Color.fromARGB(255, 255, 255, 255), // Color del ícono en cian
                      size: 36.0, // Tamaño del ícono
                    ),
                    onPressed: _speak, // Llama a la función para hablar el texto
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
