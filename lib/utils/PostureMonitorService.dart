import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class PostureMonitorService with ChangeNotifier {
  bool _isMonitoring = false;
  String _status = 'Idle';
  double _angle = 0.0;

  StreamSubscription? _accelerometerSubscription;
  Timer? _idleTimer;
  DateTime? _lastMovementTime;

  bool get isMonitoring => _isMonitoring;
  String get status => _status;
  double get angle => _angle;

  void toggleMonitoring() {
    if (_isMonitoring) {
      stopMonitoring();
    } else {
      startMonitoring();
    }
  }

  void startMonitoring() {
    _isMonitoring = true;
    _status = 'Good';
    notifyListeners();

    _lastMovementTime = DateTime.now();

    // Start accelerometer stream
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      final currentAngle = _calculateTiltAngle(event.x, event.y, event.z);
      _angle = currentAngle;

      if (currentAngle > 15) {
        _status = 'Slouching';
      } else {
        _status = 'Good';
      }

      _lastMovementTime = DateTime.now();
      notifyListeners();
    });

    // Idle detection every 10s
    _idleTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (!_isMonitoring) return;

      final idleDuration = DateTime.now().difference(_lastMovementTime ?? DateTime.now()).inSeconds;
      if (idleDuration > 30) {
        _status = 'Idle';
        notifyListeners();
      }
    });
  }

  void stopMonitoring() {
    _isMonitoring = false;
    _status = 'Idle';
    _angle = 0.0;

    _accelerometerSubscription?.cancel();
    _idleTimer?.cancel();

    notifyListeners();
  }

  double _calculateTiltAngle(double x, double y, double z) {
    final gX = x / 9.81;
    final gY = y / 9.81;
    final gZ = z / 9.81;

    final pitch = atan2(-gX, sqrt(gY * gY + gZ * gZ));
    final degrees = pitch * (180 / pi);
    return degrees.abs();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _idleTimer?.cancel();
    super.dispose();
  }
}
