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
                      if (snapshot.hasData) {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final data = snapshot.data![index];
                              return Card(
                                elevation: 2,
                                child: ListTile(
                                  title: Text(data.device.name),
                                  subtitle: Text(data.device.id.id),
                                  trailing: Text(data.rssi.toString()),
                                  onTap: () => controller.connectToDevice(data.device),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(child: Text('Nessun dispositivo trovato'));
                      }
                    },
                  ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {controller.scanDevices();},
                  child: const Text('Scansiona'),),
              ],
            ),
          );
        },
      ),
    );
  }
}
