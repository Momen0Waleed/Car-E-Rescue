import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class UserDiagnoseRepo {
  BluetoothConnection? _connection;
  Timer? _pollingTimer;

  final _statusController = StreamController<String>.broadcast();
  final _dataController = StreamController<Map<String, String>>.broadcast();

  Stream<String> get statusStream => _statusController.stream;
  Stream<Map<String, String>> get rawDataStream => _dataController.stream;

  Map<String, String> currentData = {
    "RPM": "0", "Speed": "0", "Temp": "0", "Voltage": "0.0", "Fuel": "0",
    "Throttle": "0", "Ambient": "0", "OilTemp": "0", "Runtime": "0",
    "Baro": "0", "Load": "0", "FuelPressure": "0", "IntakeTemp": "0"
  };

  Future<void> connect() async {
    if (await _requestPermissions()) {
      _statusController.add("Scanning...");
      List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      BluetoothDevice? obd = devices.firstWhere(
            (d) => d.name != null && (d.name!.contains("OBD") || d.name!.contains("ELM")),
      );

      try {
        _statusController.add("Connecting...");
        _connection = await BluetoothConnection.toAddress(obd.address);

        await _sendAsync("AT Z\r");
        await _sendAsync("AT E0\r");
        await _sendAsync("AT SP 0\r");

        _statusController.add("Connected");
        _connection!.input!.listen(_onDataReceived).onDone(() {
          _statusController.add("Disconnected");
          stopPolling();
        });
        _startPolling();
      } catch (e) {
        _statusController.add("Connection Failed");
      }
        }
  }

  void _startPolling() {
    int step = 0;
    _pollingTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_connection?.isConnected ?? false) {
        if (step % 2 == 0) {
          step % 4 == 0 ? _send("01 0C\r") : _send("01 0D\r");
        } else {
          int lowIdx = step ~/ 2;
          List<String> commands = ["01 05", "AT RV", "01 2F", "01 11", "01 46", "01 5C", "01 1F", "01 33", "01 04", "01 0A"];
          if (lowIdx < commands.length) _send("${commands[lowIdx]}\r");
        }
        step = (step + 1) % 20;
      }
    });
  }

  void _send(String cmd) => _connection?.output.add(ascii.encode(cmd));

  Future<void> _sendAsync(String cmd) async {
    _send(cmd);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _onDataReceived(Uint8List data) {
    String response = ascii.decode(data).replaceAll(RegExp(r'[\s>]'), '');
    if (response.contains("410C")) _updateRPM(response);
    if (response.contains("410D")) _updateSpeed(response);
    if (response.contains("4105")) _updateTemp(response, "Temp");
    if (response.contains("412F")) _updatePercentage(response, "Fuel");
    if (response.contains("4111")) _updatePercentage(response, "Throttle");
    if (response.contains("4146")) _updateTemp(response, "Ambient");
    if (response.contains("415C")) _updateTemp(response, "OilTemp");
    if (response.contains("411F")) _updateRuntime(response);
    if (response.contains("4133")) _updateSimple(response, "Baro");
    if (response.contains("4104")) _updatePercentage(response, "Load");
    if (response.contains("410A")) _updatePressure(response, "FuelPressure");
    if (response.contains("410F")) _updateTemp(response, "IntakeTemp");
    _dataController.add(currentData);
  }


  void _updateRPM(String res) {
    int idx = res.indexOf("410C");
    if (res.length >= idx + 8) {
      String hex = res.substring(idx + 4, idx + 8);
      double val = int.parse(hex, radix: 16) / 4;
      currentData["RPM"] = val.toStringAsFixed(0);
    }
  }

  void _updateSpeed(String res) {
    int idx = res.indexOf("410D");
    if (res.length >= idx + 6) {
      String hex = res.substring(idx + 4, idx + 6);
      currentData["Speed"] = int.parse(hex, radix: 16).toString();
    }
  }

  void _updateTemp(String res, String key) {
    int idx = res.indexOf(RegExp(r'41(05|46|5C|0F)'));
    if (idx != -1 && res.length >= idx + 6) {
      String hex = res.substring(idx + 4, idx + 6);
      currentData[key] = (int.parse(hex, radix: 16) - 40).toString();
    }
  }

  void _updatePercentage(String res, String key) {
    int idx = res.indexOf(RegExp(r'41(2F|11|04)'));
    if (idx != -1 && res.length >= idx + 6) {
      String hex = res.substring(idx + 4, idx + 6);
      double val = (int.parse(hex, radix: 16) * 100) / 255;
      currentData[key] = val.toStringAsFixed(1);
    }
  }

  void _updateRuntime(String res) {
    int idx = res.indexOf("411F");
    if (res.length >= idx + 8) {
      String hex = res.substring(idx + 4, idx + 8);
      int seconds = int.parse(hex, radix: 16);
      currentData["Runtime"] = (seconds / 60).toStringAsFixed(1);
    }
  }

  void _updatePressure(String res, String key) {
    int idx = res.indexOf("410A");
    if (res.length >= idx + 6) {
      String hex = res.substring(idx + 4, idx + 6);
      currentData[key] = (int.parse(hex, radix: 16) * 3).toString();
    }
  }

  void _updateSimple(String res, String key) {
    int idx = res.indexOf("4133");
    if (res.length >= idx + 6) {
      String hex = res.substring(idx + 4, idx + 6);
      currentData[key] = int.parse(hex, radix: 16).toString();
    }
  }
  Future<bool> _requestPermissions() async {
    return (await [Permission.bluetoothScan, Permission.bluetoothConnect, Permission.location].request())
        .values.every((p) => p.isGranted);
  }

  void stopPolling() => _pollingTimer?.cancel();
  void dispose() {
    stopPolling();
    _connection?.dispose();
    _statusController.close();
    _dataController.close();
  }
}