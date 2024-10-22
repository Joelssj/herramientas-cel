import 'package:flutter/material.dart'; 
import 'package:mobile_scanner/mobile_scanner.dart'; 


class QrScreen extends StatelessWidget {
  const QrScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Escáner de QR',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)), 
        ),
        backgroundColor: Color.fromARGB(255, 24, 24, 24), 
        iconTheme: IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      body: Container(
        color: Colors.black,
        child: MobileScanner( 
          onDetect: (BarcodeCapture capture) { 
            final List<Barcode> barcodes = capture.barcodes; 
            for (final barcode in barcodes) { 
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Código escaneado: ${barcode.rawValue}', 
                    style: TextStyle(color: Colors.white), 
                  ),
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255), 
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
