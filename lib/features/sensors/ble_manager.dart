
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum SensorState { off, scanning, connecting, ready, streaming }

class BleManager {
  final _state = StreamController<SensorState>.broadcast();
  final _hr = StreamController<int>.broadcast();
  Stream<SensorState> get state => _state.stream;
  Stream<int> get heartRate => _hr.stream;
  BluetoothDevice? _device;

  Future<void> connectPolarH10() async {
    _state.add(SensorState.scanning);
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    await for (final res in FlutterBluePlus.scanResults) {
      final hit = res.where((r) => r.device.platformName.toLowerCase().contains('polar'));
      if (hit.isNotEmpty) {
        FlutterBluePlus.stopScan();
        final dev = hit.first.device;
        _device = dev;
        _state.add(SensorState.connecting);
        await dev.connect();
        _state.add(SensorState.ready);
        final services = await dev.discoverServices();
        final hrService = services.firstWhere((s) => s.uuid.str.toLowerCase().contains('180d'), orElse: ()=>services.first);
        final hrChar = hrService.characteristics.firstWhere((c) => c.uuid.str.toLowerCase().contains('2a37'), orElse: ()=>hrService.characteristics.first);
        await hrChar.setNotifyValue(true);
        _state.add(SensorState.streaming);
        hrChar.onValueReceived.listen((data) {
          if (data.isEmpty) return;
          final bpm = data.length > 1 ? data[1] : 0;
          _hr.add(bpm);
        });
        break;
      }
    }
  }

  Future<void> disconnect() async { if (_device!=null) await _device!.disconnect(); _state.add(SensorState.off); }
}
