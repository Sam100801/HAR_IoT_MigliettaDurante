import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BleController extends GetxController {
  FlutterBlue ble = FlutterBlue.instance;

  // Dispositivo connesso
  var connectedDevice = Rx<BluetoothDevice?>(null);

  // Informazioni ricevute dal dispositivo
  var deviceInfo = RxString('');

  // Lista di caratteristiche
  var characteristics = <BluetoothCharacteristic>[].obs;

  // Mappa per le notifiche in tempo reale
  var notifications = <Guid, List<int>>{}.obs;

  Future<void> scanDevices() async {
    final bluetoothScanStatus = await Permission.bluetoothScan.request();
    final bluetoothConnectStatus = await Permission.bluetoothConnect.request();
    final locationStatus = await Permission.locationWhenInUse.request();

    if (bluetoothScanStatus.isGranted &&
        bluetoothConnectStatus.isGranted &&
        locationStatus.isGranted) {
      // Avvia la scansione dei dispositivi BLE
      ble.startScan(timeout: Duration(seconds: 60));

      ble.scanResults.listen((results) {
        // Gestisci i risultati della scansione
        print('Found ${results.length} devices');
      });

      await Future.delayed(Duration(seconds: 60));
      ble.stopScan();
    } else {
      print('Permessi necessari non concessi');
    }
  }

  Future<void> connectToDevice(BluetoothDevice device, Function() onConnected) async {
    try {
      await device.connect(timeout: Duration(seconds: 36000));
      connectedDevice.value = device;

      // Monitora lo stato di connessione del dispositivo
      device.state.listen((BluetoothDeviceState state) {
        if (state == BluetoothDeviceState.connected) {
          print("Device connected: ${device.name}");
          onConnected(); // Chiama il callback quando connesso
          _discoverServices(device);
        } else if (state == BluetoothDeviceState.disconnected) {
          print("Device Disconnected");
          connectedDevice.value = null;
          deviceInfo.value = ''; // Resetta le informazioni quando disconnesso
          characteristics.clear(); // Resetta le caratteristiche
          notifications.clear(); // Resetta le notifiche
        }
      });
    } catch (e) {
      print('Errore durante la connessione: $e');
    }
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristics.add(characteristic);

        // Legge i valori delle caratteristiche se possibile
        if (characteristic.properties.read) {
          var value = await characteristic.read();
          deviceInfo.value += 'Characteristic ${characteristic.uuid}: $value\n';
        }

        // Monitora le notifiche se la caratteristica supporta il notify
        if (characteristic.properties.notify) {
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((value) {
            // Aggiorna la mappa delle notifiche in tempo reale
            notifications[characteristic.uuid] = value;
            deviceInfo.value += 'Notification from ${characteristic.uuid}: $value\n';
          });
        }
      }
    }
  }

  // Metodo per disconnettere il dispositivo
  Future<void> disconnectFromDevice(Function() onDisconnected) async {
    final device = connectedDevice.value;
    if (device != null) {
      await device.disconnect();
      connectedDevice.value = null;
      deviceInfo.value = ''; // Resetta le informazioni quando disconnesso
      characteristics.clear(); // Resetta le caratteristiche
      notifications.clear(); // Resetta le notifiche
      onDisconnected(); // Chiama il callback quando disconnesso
    }
  }

  // Stream per ottenere i risultati della scansione
  Stream<List<ScanResult>> get scanResults => ble.scanResults;
}
