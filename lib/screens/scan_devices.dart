import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:prova_flutter/controller/ble_controller.dart';

class ScanDevices extends StatefulWidget {
  const ScanDevices({super.key});

  @override
  State<ScanDevices> createState() => _ScanDevicesState();
}

class _ScanDevicesState extends State<ScanDevices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivi trovati'),
        backgroundColor: Colors.lightBlue,
      ),
      body: GetBuilder<BleController>(
        init: BleController(),
        builder: (BleController controller) {
          return Center(
            child: Column(
              children: [
                StreamBuilder<List<ScanResult>>(
                  stream: controller.scanResults,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];
                            return Card(
                              elevation: 2,
                              child: ListTile(
                                title: Text(data.device.name.isNotEmpty ? data.device.name : "Dispositivo sconosciuto"),
                                subtitle: Text(data.device.id.id),
                                trailing: Text('RSSI: ${data.rssi}'),
                                onTap: () async {
                                  await controller.connectToDevice(data.device);
                                  if (controller.deviceInfo.value.isNotEmpty) {
                                    _showDeviceInfoDialog(context, controller.deviceInfo.value);
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return const Expanded(
                        child: Center(child: Text('Nessun dispositivo trovato')),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    controller.scanDevices();
                  },
                  child: const Text('Scansiona'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDeviceInfoDialog(BuildContext context, String deviceInfo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informazioni Dispositivo'),
          content: SingleChildScrollView(
            child: Text(deviceInfo),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Chiudi il dialog
              },
            ),
          ],
        );
      },
    );
  }
}
