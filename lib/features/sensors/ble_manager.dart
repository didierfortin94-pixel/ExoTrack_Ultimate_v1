import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

enum SensorState { off, scanning, connecting, ready, streaming }

class BleManager {
  static const _heartRateServiceShortId = '180d';
  static const _heartRateMeasurementShortId = '2a37';

  final _state = StreamController<SensorState>.broadcast();
  final _heartRate = StreamController<int>.broadcast();

  Stream<SensorState> get state => _state.stream;
  Stream<int> get heartRate => _heartRate.stream;

  BluetoothDevice? _device;
  StreamSubscription<List<int>>? _hrSubscription;
  SensorState _currentState = SensorState.off;

  SensorState get currentState => _currentState;

  void _emitState(SensorState state) {
    _currentState = state;
    if (!_state.isClosed) {
      _state.add(state);
    }
  }

  Future<bool> connectPolarH10({Duration scanTimeout = const Duration(seconds: 5)}) async {
    _emitState(SensorState.scanning);

    try {
      await FlutterBluePlus.startScan(timeout: scanTimeout);

      final scanMatch = await FlutterBluePlus.scanResults
          .asyncExpand((results) => Stream.fromIterable(results))
          .timeout(scanTimeout, onTimeout: (sink) => sink.close())
          .firstWhere(
            (result) => result.device.platformName.toLowerCase().contains('polar'),
          );

      _device = scanMatch.device;
    } on TimeoutException catch (_) {
      _emitState(SensorState.off);
      return false;
    } on StateError catch (_) {
      _emitState(SensorState.off);
      return false;
    } on Exception {
      _emitState(SensorState.off);
      return false;
    } finally {
      await FlutterBluePlus.stopScan();
    }

    final device = _device;
    if (device == null) {
      _emitState(SensorState.off);
      return false;
    }

    _emitState(SensorState.connecting);
    try {
      await device.connect(
        timeout: const Duration(seconds: 10),
        license: License.free,
      );
    } on Exception {
      await disconnect();
      return false;
    }

    _emitState(SensorState.ready);

    final services = await device.discoverServices();
    BluetoothService? hrService;
    for (final service in services) {
      final id = service.uuid.str.toLowerCase();
      if (id.contains(_heartRateServiceShortId)) {
        hrService = service;
        break;
      }
    }
    if (hrService == null) {
      await disconnect();
      return false;
    }

    BluetoothCharacteristic? hrCharacteristic;
    for (final characteristic in hrService.characteristics) {
      final id = characteristic.uuid.str.toLowerCase();
      if (id.contains(_heartRateMeasurementShortId)) {
        hrCharacteristic = characteristic;
        break;
      }
    }
    if (hrCharacteristic == null) {
      await disconnect();
      return false;
    }

    try {
      await hrCharacteristic.setNotifyValue(true);
    } on Exception {
      await disconnect();
      return false;
    }
    await _hrSubscription?.cancel();
    _hrSubscription = hrCharacteristic.lastValueStream.listen((data) {
      if (data.isEmpty) {
        return;
      }
      final bpm = data.length > 1 ? data[1] : data.first;
      if (!_heartRate.isClosed) {
        _heartRate.add(bpm);
      }
    });

    _emitState(SensorState.streaming);
    return true;
  }

  Future<void> disconnect() async {
    await _hrSubscription?.cancel();
    _hrSubscription = null;

    final device = _device;
    if (device != null) {
      try {
        await device.disconnect();
      } catch (_) {
        // Ignore disconnection errors; device might already be disconnected.
      }
      _device = null;
    }

    _emitState(SensorState.off);
  }

  Future<void> dispose() async {
    await disconnect();
    await _state.close();
    await _heartRate.close();
  }
}
