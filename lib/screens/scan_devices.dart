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
        actions: [
          // Icona di disconnessione
          IconButton(
            icon: const Icon(Icons.bluetooth_disabled),
            onPressed: () async {
              await Get.find<BleController>().disconnectFromDevice(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Dispositivo disconnesso'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              });
            },
          ),
        ],
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
                      // Filtra i dispositivi sconosciuti
                      final filteredResults = snapshot.data!
                          .where((result) => result.device.name.isNotEmpty)
                          .toList();

                      if (filteredResults.isEmpty) {
                        return const Expanded(
                          child: Center(child: Text('Nessun dispositivo conosciuto trovato')),
                        );
                      }

                      return Expanded(
                        child: ListView.builder(
                          itemCount: filteredResults.length,
                          itemBuilder: (context, index) {
                            final data = filteredResults[index];
                            return Card(
                              elevation: 2,
                              child: ListTile(
                                title: Text(data.device.name),
                                subtitle: Text(data.device.id.id),
                                trailing: Text('RSSI: ${data.rssi}'),
                                onTap: () async {
                                  await controller.connectToDevice(data.device, () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Dispositivo ${data.device.name} connesso'),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  });
                                  if (controller.deviceInfo.value.isNotEmpty) {
                                    _showDeviceInfoDialog(
                                        context, controller.deviceInfo.value);
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
                const SizedBox(height: 20),

                // Sezione per visualizzare in tempo reale le caratteristiche
                Obx(() {
                  if (controller.characteristics.isEmpty) {
                    return const Text('Nessuna caratteristica trovata');
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: controller.characteristics.length,
                        itemBuilder: (context, index) {
                          final characteristic = controller.characteristics[index];
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text('Caratteristica: ${characteristic.uuid}'),
                              subtitle: Obx(() {
                                // Visualizza i dati delle notifiche in tempo reale
                                final value = controller.notifications[characteristic.uuid];
                                return Text('Valore: ${value != null ? value.toString() : 'N/A'}');
                              }),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
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