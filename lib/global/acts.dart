import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

Future<dynamic> connect(connection , address) async {
  try {
    print('Connecting to address');
    connection ??= await BluetoothConnection.toAddress(address);
    print('Connected');
    return connection;
  } catch (e) {
    connection = null;
    return connection;
  }
}

