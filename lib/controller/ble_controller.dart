import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {

  FlutterBlue ble = FlutterBlue.instance;

  Future<void> scanDevices() async {
    final bluetoothScanStatus = await Permission.bluetoothScan.request();
    final bluetoothConnectStatus = await Permission.bluetoothConnect.request();
    final locationStatus = await Permission.locationWhenInUse.request();

    if (bluetoothScanStatus.isGranted &&
        bluetoothConnectStatus.isGranted &&
        locationStatus.isGranted) {
      // Avvia la scansione dei dispositivi BLE
      ble.startScan(timeout: Duration(seconds: 15));

      ble.scanResults.listen((results) {
        // Gestisci i risultati della scansione
        print('Found ${results.length} devices');
      });

      await Future.delayed(Duration(seconds: 15));
      ble.stopScan();
    } else {
      print('Permessi necessari non concessi');
    }
  }

  // Questa funzione aiuterà l'utente a connettersi ai dispositivi BLE.
  Future<void> connectToDevice(BluetoothDevice device) async {
    // Connetti al dispositivo
    await device.connect(timeout: Duration(seconds: 15));

    // Aggiungi un listener per gestire lo stato di connessione
    device.state.listen((BluetoothDeviceState state) {
      if (state == BluetoothDeviceState.connecting) {
        print("Device connecting to: ${device.name}");
      } else if (state == BluetoothDeviceState.connected) {
        print("Device connected: ${device.name}");
      } else if (state == BluetoothDeviceState.disconnected) {
        print("Device Disconnected");
      }
    });
  }

  Stream<List<ScanResult>> get scanResults => ble.scanResults;
}
